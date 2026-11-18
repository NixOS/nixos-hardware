{
  lib,
  stdenv,
  fetchFromGitHub,
  ubootTools,
  dtc,
  python3,
  xz,
  # DRAM init is the one part of BL2 that cannot be copied from BL31: it runs
  # before any memory exists.  MediaTek ships one config per DDR population, and
  # `DRAM_USE_COMB=1` ("detect at runtime from the combined table") is what
  # OpenWrt selects for trusted-firmware-a-mt7988-sdmmc-comb.
  #
  # Exposed as an argument because the bisect cannot otherwise separate this
  # from a FIP/BL31 problem: with our BL2 the board reset-loops at "Jump to BL"
  # and never prints a BL31 banner, while the VENDOR BL2 driving the same FIP
  # boots fine.  To test an alternative:
  #   pkgs.callPackage ./atf.nix { dramFlag = "DRAM_USE_DDR4=1"; }
  dramFlag ? "DRAM_USE_COMB=1",
  ...
}:

# MediaTek MT7988 ARM Trusted Firmware (BL2 preloader + BL31 monitor).
#
# WHY THIS IS NOT nixpkgs' arm-trusted-firmware
# ---------------------------------------------
# Upstream TF-A has NO mt7988 platform: `plat/mediatek/` there carries mt8188
# only.  MT7988 support lives exclusively in MediaTek's downstream ATF, which
# is the tree OpenWrt builds from.  This derivation pins the exact commit
# OpenWrt ships (package/boot/arm-trusted-firmware-mediatek, PROTO=git,
# PLAT=mt7988) so the boot chain is reproducible from a known-good source
# rather than from a vendored vendor blob.
#
# WHAT IT PRODUCES
# ----------------
#   bl2.img : the MT7988 SD preloader.  The BootROM loads it from RAW SECTOR 34
#             of the microSD -- it is not a partition and not a file, so
#             nothing in NixOS's partitioning can place it.  `mk-sd-image.sh`
#             dd's this at seek=34.
#   bl31.bin: the EL3 runtime monitor, packed into the FIP together with
#             U-Boot (BL33) by ./fip.nix.
#
# The boot-ROM header is applied with `mkimage -T mtk_image` (the same tool
# OpenWrt uses when USE_MKIMAGE=1).  Signing is deliberately NOT enabled:
# `TRUSTED_BOARD_BOOT` gates only signature *verification* of the FIP, and the
# retail board ships with eFuses unblown, so BL2 loads an unsigned FIP.  Signing
# would need an MBEDTLS_DIR and a key we do not have, and would make the boot
# chain depend on a secret that is not recoverable.
let
  # Board geometry: microSD, combo (LPDDR) DRAM -- the same BUILD_VARIANT
  # OpenWrt uses for `mt7988_bananapi_bpi-r4-sdmmc`
  # (trusted-firmware-a-mt7988-sdmmc-comb).
  bootDevice = "sdmmc";

  # The single source of truth for the ATF tree.  ./fip.nix reuses this exact
  # source to build `fiptool`, so the FIP container format can never drift from
  # the BL2 that parses it.
  atfSource = fetchFromGitHub {
    owner = "mtk-openwrt";
    repo = "arm-trusted-firmware";
    rev = "bacca82a8cac369470df052a9d801a0ceb9b74ca";
    hash = "sha256-n5D3styntdoKpVH+vpAfDkCciRJjCZf9ivrI9eEdyqw=";
  };
in
# OpenWrt 24.10 builds this exact package with GCC 13.3.0 / binutils 2.42
# (toolchain/gcc/Config.version, toolchain/binutils/Config.version).  The nix
# stdenv here is GCC 15, which produces a *different binary from the same
# source*: comparing our bl2.img against OpenWrt's shows identical wrappers
# and identical code up to 0x968, then ~5400 instructions unique on each side.
# A preloader that never prints its banner is exactly what a codegen change in
# BL2's early init looks like, so build with the same major the working image
# used.
stdenv.mkDerivation (_finalAttrs: {
  pname = "arm-trusted-firmware-mt7988";
  version = "2024-01-17";

  src = atfSource;

  # MT7988 ignores a WDT_SWRST write unless WDT_SWSYSRST_EN (0xfc) is set
  # first.  This ATF's mtk_wdt_soft_reset() never sets it, so the write is
  # dropped, the function returns, and the PSCI SYSTEM_RESET/SYSTEM_OFF
  # handler in plat_pm.c parks the core in wfi() and panics -- the board then
  # hangs and needs a power cycle.  That is exactly the symptom this board
  # shows for BOTH `systemctl reboot` and `shutdown now`.
  #
  # The Linux driver already does the right thing for the same SoC
  # (mt7988_data.has_swsysrst_en = true in drivers/watchdog/mtk_wdt.c).
  # This patch makes BL31 match it.
  #
  # VERIFIED in the built bl31.bin with Ghidra (module entry 0x4068, which is
  # mtk_wdt_soft_reset -- it is the only function referencing WDT_MODE_KEY
  # 0x22000000):
  #
  #   old: 0x4068..0x40ca, no access to offset 0xf4
  #   new: 0x4068..0x40d6
  #          000040b8  mov w1,#0x1
  #          000040bc  str w1,[x0,#0xf4]    x0=0x1001c008 -> 0x1001c0fc (SW_SYSRST_EN)
  #          000040c4  ldr w1,[x0,#0xc]                         -> 0x1001c014 (SWRST)
  #          000040cc  str w1,[x0,#0xc]
  #          000040d0  str wzr,[x0,#0xf4]   cleanup, only reached if it did not fire
  #
  # Note when reading this in a decompiler: Ghidra folds the pair into
  # "_DAT_1001c0fc = 0" and hides the =1 write, which looks like the patch did
  # nothing. The disassembly above is the ground truth.
  patches = [ ./patches/0001-mtk-wdt-set-SWSYSRST_EN-before-SWRST.patch ];

  passthru = { inherit atfSource; };

  nativeBuildInputs = [
    ubootTools # mkimage -T mtk_image (the BL2 boot-ROM header)
    dtc
    (python3.withPackages (ps: [ ps.pyelftools ])) # fiptool/bl2 tools
    xz
  ];

  # OpenWrt passes CROSS_COMPILE and builds AArch64 from a 64-bit host directly.
  # Do the same here so the output is byte-comparable with theirs.
  #
  # These flags mirror TFA_MAKE_FLAGS in OpenWrt's
  # package/boot/arm-trusted-firmware-mediatek/Makefile for the
  # `mt7988-sdmmc-comb` variant -- the exact variant this board uses:
  #
  #   BOOT_DEVICE=$(BOOT_DEVICE)                       -> sdmmc
  #   USE_MKIMAGE=1 MKIMAGE=$(STAGING_DIR_HOST)/bin/mkimage
  #   $(if $(findstring ddr4,$(DDR_TYPE)),DRAM_USE_DDR4=1)
  #   $(if $(BOARD_QFN),BOARD_QFN=1,BOARD_BGA=1)       -> BOARD_BGA=1
  #   HAVE_DRAM_OBJ_FILE=yes
  #   $(if $(DRAM_USE_COMB),DRAM_USE_COMB=1)           -> set for *-comb
  #
  # MEASURED: adding these two flags leaves bl2.img BYTE-IDENTICAL to the build
  # without them, so they are no-ops on mt7988 despite OpenWrt passing them
  # unconditionally.  They are kept only so the flag list matches OpenWrt's
  # verbatim; do not read them as a fix for anything.
  makeFlags = [
    "PLAT=mt7988"
    "BOOT_DEVICE=${bootDevice}"
    dramFlag
    "USE_MKIMAGE=1"
    "MKIMAGE=mkimage"
    "BOARD_BGA=1"
    "HAVE_DRAM_OBJ_FILE=yes"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    # Stamp the version string with the pinned source + variant instead of
    # letting TF-A run `git describe` in the build tree.  Without this
    # BUILD_STRING is empty and the banner reads "v2.10.0\t(release):" with
    # nothing after it, so a serial-console capture cannot tell which preloader
    # is on the card.
    #
    # Deliberately NOT __DATE__/__TIME__: the build must be byte-reproducible,
    # so the timestamp stays at the Nix epoch (00:00:00, Jan  1 1980).
    "BUILD_STRING=NixOS-${atfSource.rev}-${bootDevice}-comb"
    "all"
  ];

  enableParallelBuilding = true;

  # Pin the build clock so __DATE__/__TIME__ are reproducible.  Without it the
  # values come from whenever the builder ran, which would make two builds of
  # the same source differ and destroy the byte comparison against OpenWrt's
  # preloader.  Nix leaves SOURCE_DATE_EPOCH unset, so set it explicitly to
  # 1980-01-01T00:00:00Z (the value the previous builds happened to get).
  SOURCE_DATE_EPOCH = "315532800";

  # TF-A's build writes into its own build/ dir and shells out to python for
  # the tool wrappers; hardening flags would break its freestanding AArch64
  # objects (it passes -nostdinc and its own CC flags).
  hardeningDisable = [ "all" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp build/mt7988/release/bl2.img $out/bl2.img
    cp build/mt7988/release/bl31.bin $out/bl31.bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "MediaTek MT7988 ARM Trusted Firmware (BL2 + BL31) for the BPI-R4 Pro";
    homepage = "https://github.com/mtk-openwrt/arm-trusted-firmware";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})

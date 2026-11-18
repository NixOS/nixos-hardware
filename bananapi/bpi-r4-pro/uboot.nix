{
  lib,
  stdenv,
  fetchFromGitHub,
  bc,
  bison,
  flex,
  dtc,
  gnutls,
  openssl,
  python3,
  swig,
  libuuid,
  buildPackages,
  ...
}:

# U-Boot (BL33) for the Banana Pi BPI-R4 Pro, built for the SD boot path.
#
# WHY NOT nixpkgs' ubootPackages
# -----------------------------
# nixpkgs' u-boot has MT7988 *SoC* support (mt7988_rfb_defconfig) but no
# BPI-R4 Pro defconfig: the board has not reached a mainline defconfig yet.
# frank-w carries `mt7988a_bpir4pro_sd_defconfig` in `2026-04-bpi`, which this
# pins.  When that defconfig reaches u-boot/master this collapses to
# `pkgs.ubootPackages.*`.
#
# WHY EFI IS ENABLED
# ------------------
# Every MediaTek ARMv8 defconfig upstream sets `# CONFIG_EFI_LOADER is not
# set`.  Nothing in the hardware requires that -- it is a space decision --
# and enabling it is what lets the board boot a NixOS ESP with stock
# systemd-boot instead of a hand-rolled FIT (see ./efi.nix).
#
# The FIT this replaces carried an ABSOLUTE `init=` pointing at a store path,
# which pinned every reboot to whichever generation produced that FIT: a
# `nixos-rebuild boot` moved the profile while the board kept booting the old
# toplevel, and flashing a trial generation made that un-escapable without
# serial surgery.  An ESP with real generation entries removes that class of
# failure outright.
#
# `bootstd` (extlinux + EFI loader) and the classic load commands are both
# enabled on purpose, so a serial console can always reach a kernel by hand if
# the ESP or the GPT is damaged.
let
  # Layered on the board defconfig via `scripts/config` (the supported way --
  # it keeps Kconfig dependencies consistent), then normalised by olddefconfig.
  # The configurePhase asserts the EFI-related symbols survive that step, so
  # this firmware cannot silently regress to a FIT-only build.
  efibootConfig = [
    # --- boot a NixOS ESP ---
    "CONFIG_CMD_BOOTEFI=y"
    "CONFIG_CMD_BOOTEFI_BOOTMGR=y"
    "CONFIG_EFI_LOADER=y"
    "CONFIG_EFI_LOADER_BOUNCE_BUFFER=y"
    # Keep EFI variables in RAM: the boot medium is an image with no EFIVAR
    # partition to persist them to.
    "CONFIG_EFI_VARIABLES_PRESEED=n"
    # --- standard boot ---
    "CONFIG_BOOTSTD=y"
    "CONFIG_BOOTSTD_FULL=y"
    "CONFIG_BOOTSTD_DEFAULTS=y"
    "CONFIG_BOOTMETH_EXTLINUX=y"
    "CONFIG_BOOTMETH_EFILOADER=y"
    "CONFIG_CMD_BOOTFLOW=y"
    "CONFIG_CMD_BOOTMETH=y"
    "CONFIG_AUTOBOOT=y"
    "CONFIG_BOOTDELAY=2"
    # --- filesystems ---
    "CONFIG_CMD_EXT4=y"
    "CONFIG_CMD_FAT=y"
    "CONFIG_CMD_FS_GENERIC=y"
    "CONFIG_CMD_PART=y"
    "CONFIG_PARTITION_TYPE_GUID=y"
    "CONFIG_DOS_PARTITION=y"
    "CONFIG_EFI_PARTITION=y"
    # --- block devices the root/ESP live on ---
    "CONFIG_CMD_MMC=y"
    "CONFIG_MMC_MTK=y"
    "CONFIG_MMC_HS200_SUPPORT=y"
    "CONFIG_PCI=y"
    "CONFIG_PCIE_MEDIATEK_GEN3=y"
    "CONFIG_NVME=y"
    "CONFIG_NVME_PCI=y"
    "CONFIG_CMD_NVME=y"
    "CONFIG_CMD_PCI=y"
    "CONFIG_BLK=y"
    "CONFIG_USB=y"
    "CONFIG_USB_XHCI_HCD=y"
    "CONFIG_USB_XHCI_MTK=y"
    "CONFIG_USB_STORAGE=y"
    "CONFIG_CMD_USB=y"
    # --- rescue tooling over the serial console ---
    "CONFIG_CMD_ENV=y"
    "CONFIG_CMD_GPIO=y"
    "CONFIG_CMD_PINMUX=y"
    "CONFIG_CMD_I2C=y"
    "CONFIG_CMD_CACHE=y"
    "CONFIG_CMD_CLK=y"
    "CONFIG_CMD_RESET=y"
    "CONFIG_CMD_PSTORE=y"
    "CONFIG_CMD_PSTORE_MEM_ADDR=0x42ff0000"
    "CONFIG_CMD_PSTORE_RECORD_SIZE=0x2000"
    "CONFIG_CMD_PSTORE_CONSOLE_SIZE=0x0"
    "CONFIG_CMD_PSTORE_FTRACE_SIZE=0x0"
    "CONFIG_CMD_PSTORE_PMSG_SIZE=0x2000"
  ];

  # Renders the list above as `scripts/config` invocations.  `scripts/config`
  # has a `#!/usr/bin/env bash` shebang and there is no /usr/bin/env in the
  # build sandbox, so it is always invoked through bash.
  configCommands = lib.concatMapStringsSep "\n" (
    opt:
    let
      parts = lib.splitString "=" opt;
      name = lib.removePrefix "CONFIG_" (builtins.head parts);
      value =
        if builtins.length parts > 1 then builtins.concatStringsSep "=" (builtins.tail parts) else null;
      verb =
        if value == "n" then
          "--disable"
        else if value == null || value == "y" then
          "--enable"
        else
          "--set-val";
    in
    "bash scripts/config --file .config ${verb} ${name}${
      lib.optionalString (verb == "--set-val") " ${value}"
    }"
  ) efibootConfig;

  # Host tools (fixdep, binman, mkimage) are compiled by U-Boot's Makefile and
  # executed immediately, so they need the NATIVE compiler and must link
  # against native openssl/gnutls/libuuid.  nixpkgs' compiler wrapper is
  # bypassed by HOSTCC, so the include/library paths are supplied explicitly
  # through HOSTCFLAGS/HOSTLDFLAGS.
  hostLibs = [
    buildPackages.openssl
    buildPackages.gnutls
    buildPackages.util-linux
  ];
  hostCflags = lib.concatMapStringsSep " " (p: "-I${lib.getDev p}/include") hostLibs;
  hostLdflags = lib.concatMapStringsSep " " (p: "-L${lib.getLib p}/lib") hostLibs;

  # U-Boot needs HOSTCC pointed at the native compiler explicitly; otherwise it
  # invokes `cc` from PATH (the cross wrapper) when building host tools.
  hostArgs = "HOSTCC=${buildPackages.stdenv.cc}/bin/cc";
in
stdenv.mkDerivation {
  pname = "u-boot-bpi-r4-pro";
  version = "2026.04-bpi";

  src = fetchFromGitHub {
    owner = "frank-w";
    repo = "u-boot";
    rev = "2760d5001537cfdd5ce38a0e1d1707e2f58b0e04";
    hash = "sha256-vIkmgNwAkcWBNTlOaD+SBsMSW0BpwczvEVusmB4WpWY=";
  };

  nativeBuildInputs = [
    bc
    bison
    flex
    dtc
    buildPackages.xxd # host-only tool, absent from the cross package set
    python3
    swig
    stdenv.cc # target compiler
  ];

  depsBuildBuild = hostLibs;

  makeFlags = [ "CROSS_COMPILE=${stdenv.cc.targetPrefix}" ];

  configurePhase = ''
    runHook preConfigure
    # U-Boot ships several `#!/usr/bin/env ...` helper scripts
    # (scripts/check-local-export, scripts/config, ...) and the build sandbox
    # has no /usr/bin/env.  Rewrite every shebang to a real interpreter once,
    # rather than special-casing each script at its call site.
    patchShebangs scripts tools

    export HOSTCFLAGS="${hostCflags}"
    export HOSTLDFLAGS="${hostLdflags}"

    make $makeFlags ${hostArgs} mt7988a_bpir4pro_sd_defconfig
    ${configCommands}
    make $makeFlags ${hostArgs} olddefconfig

    # Fail here rather than ship firmware that silently lost EFI support: the
    # whole point of this build is booting an ESP, and a regression would only
    # surface as an unbootable board on the serial console.
    for sym in CONFIG_EFI_LOADER CONFIG_CMD_BOOTEFI CONFIG_BOOTMETH_EFILOADER CONFIG_BOOTSTD; do
      grep -q "^$sym=y$" .config \
        || { echo "ERROR: $sym did not survive olddefconfig" >&2; exit 1; }
    done
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    export HOSTCFLAGS="${hostCflags}"
    export HOSTLDFLAGS="${hostLdflags}"
    make $makeFlags ${hostArgs} -j$NIX_BUILD_CORES u-boot.bin u-boot.dtb
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -m644 u-boot.bin $out/u-boot.bin
    install -m644 u-boot.dtb $out/u-boot.dtb
    install -m644 .config $out/u-boot.config
    runHook postInstall
  '';

  dontStrip = true;

  meta = with lib; {
    description = "U-Boot (BL33) with EFI loader for the Banana Pi BPI-R4 Pro (MT7988A)";
    homepage = "https://github.com/frank-w/u-boot";
    license = licenses.gpl2Plus;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}

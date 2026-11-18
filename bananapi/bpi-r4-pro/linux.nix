{
  lib,
  pkgs,
  ...
}:

# Board kernel for the Banana Pi BPI-R4 Pro (MediaTek MT7988A).
#
# Why not just nixpkgs' mainline kernel: mainline's mtk_eth_soc has NO
# USXGMII/SerDes support, so the on-board 10G switch (MxL86252) CPU conduit and
# the SFP+ cages cannot come up -- the 10G WAN/LAN is simply unsupported on
# mainline.  The board DTS itself (mt7988a-bananapi-bpi-r4-pro-4e.dts) only
# landed upstream in Linux 6.19, and its dtsi does not compile against the 6.18
# mt7988a.dtsi, so we also ship a resolved, self-contained DTS (see ./default.nix
# and ./dtb/).
#
# We therefore build nixpkgs' linux_6_18 with the curated OpenWrt MT7988
# networking delta (mtk_eth_soc USXGMII + DSA mxl862xx + PCS mtk-usxgmii/lynxi)
# applied, rebased onto nixpkgs' 6.18.55 (see
# patches/openwrt-mt7988-net-6.18.55.patch, GPL-2.0, via the
# ly4096x/BananaPi-R4-Pro-8X-OS tree).
let
  # The patch set in ./patches is rebased onto linux 6.18.5.
  #
  # `pkgs.linux_6_18` is mainline.nix, a TRACKING kernel: its version comes from
  # kernels-org.json (branch = "6.18"), so it moves to a new point release
  # whenever nixpkgs is updated -- 6.18.62 at the time of writing.  The patch
  # then fails with
  #
  #   Hunk #6 FAILED at 142.   drivers/net/pcs/pcs-mtk-lynxi.c
  #
  # which surfaces far from the cause, as a failed btrfs-fs.img deep inside the
  # SD-image closure.
  #
  # Pin the base here.  mainline.nix applies `args.argsOverride` AFTER the
  # json-derived version/src, which is why this works and
  # `linux_6_18.override { version = ...; }` does not (verified: that produced
  # src linux-6.18.62.tar.xz regardless).
  #
  # Moving to a newer 6.18.x means rebasing the patch set and bumping
  # patchBase together -- they are one unit.
  patchBase = "6.18.55";

  # The package set whose artifacts are built FOR THE BOARD.  In a cross build
  # (`pkgs` = build packages) that is pkgsCross; on a native aarch64 host it is
  # `pkgs` itself, so an on-board rebuild gets the same package.
  kernelPkgs = pkgs.pkgsCross.aarch64-multiplatform or pkgs;
  # NOTE: this must be merged into ONE override below.  A second
  # `baseKernel.override { ... }` REPLACES argsOverride wholesale and silently
  # loses the pin (that is exactly how the version stayed at 6.18.62).
in
{
  # `pkgs` here is the MODULE's package set.  When the host is cross-built
  # (nixpkgs.buildPlatform = x86_64-linux, hostPlatform = aarch64-linux), that
  # is the BUILD package set, so `pkgs.linux_6_18` is an x86_64 kernel -- which
  # is exactly how the SD image ended up with
  # "Linux kernel x86 boot executable, bzImage" for the board and U-Boot
  # rejecting it with "Machine type 0x8664 is not supported".
  #
  # Take the kernel from the TARGET package set instead.  `pkgsCross` is the
  # cross set only when a cross build is configured; on a native aarch64 host
  # (an on-board rebuild) it is `pkgs` itself, so this is the same package.
  boot.kernelPackages = lib.mkDefault (
    kernelPkgs.linuxPackagesFor (
      # NOTE the parentheses: `.overrideAttrs` must apply to the RESULT of
      # `.override`, not to the lambda passed to it.  Without them Nix parses
      # `override (prev: {...}).overrideAttrs (prev: {...})` as
      # `override ((prev: {...}).overrideAttrs) (prev: {...})`, and
      # linuxPackagesFor then receives a function ("expected a set but found a
      # function").
      (kernelPkgs.linux_6_18.override (prev: {
        # Pin the base kernel: linux_6_18 is mainline.nix and tracks 6.18.x
        # from kernels-org.json, so it drifts to a new point release whenever
        # nixpkgs moves.  mainline.nix applies argsOverride AFTER the
        # json-derived version/src, which is why this works and
        # `linux_6_18.override { version = ...; }` alone does not.
        argsOverride = {
          version = patchBase;
          modDirVersion = patchBase;
          src = kernelPkgs.fetchurl {
            url = "mirror://kernel/linux/kernel/v6.x/linux-${patchBase}.tar.xz";
            hash = "sha256-9BBjgGGhZcEvQquHHS8/zVJVFTWbX67ugJac/4RSTfk=";
          };
        };
        # Do NOT build the kernel tree's device trees.
        #
        # See the `overrideAttrs` below -- `override` cannot express this.  A
        # `buildDTBs = false` ARG is silently dropped on the cross set
        # (`pkgsCross.aarch64-multiplatform`), because `build.nix`'s default is
        # resolved from the host platform and `generic.nix` only forwards the
        # arg when it is non-null; the attribute never reappears on the
        # resulting package (verified: `builtins.tryEval pkg.buildDTBs` ->
        # missing).  Overriding the resolved `buildFlags`/`installFlags` lists
        # instead works because those are final attributes.
        kernelPatches = (prev.kernelPatches or [ ]) ++ [
          {
            name = "openwrt-mt7988-net";
            patch = ./patches/openwrt-mt7988-net-6.18.55.patch;
          }
          # mt7530-mdio.c must match the delta's reworked mtk_pcs_lynxi_create()
          # signature (dev, fwnode, regmap, ana_rgc3), otherwise it is a real
          # incompatible-pointer/int-conversion bug on the lan5 SerDes PCS path.
          {
            name = "mt7530-pcs-lynxi-sig";
            patch = ./patches/980-mt7530-match-mtk-pcs-lynxi-create-signature.patch;
          }
          # AS21010 10G PHY (the 10G RJ45 WAN/combo) fixes from the same OpenWrt
          # tree: handle pipelined C45 reads, force a pipelined no-op aneg, and
          # fix a warm-reboot pipeline lag.
          {
            name = "as21xxx-pipelined-aneg";
            patch = ./patches/976-as21xxx-bind-force-pipelined-noop-aneg.patch;
          }
          {
            name = "as21xxx-warmreboot";
            patch = ./patches/979-as21xxx-warmreboot-fix.patch;
          }
          # mtk USXGMII PCS: do not reset the line side after link-up.
          {
            name = "pcs-mtk-usxgmii-no-reset";
            patch = ./patches/977-pcs-mtk-usxgmii-no-reset-after-linkup.patch;
          }
          # Netdev-watchdog recovery: a queue stalled WITHOUT an FE error must
          # recover that netdev alone (stop/start) instead of either doing
          # nothing (the old early return left the port dead until cold boot) or
          # resetting the whole FE and bouncing every MAC (WAN included).
          {
            name = "mtk-eth-tx-timeout-single-dev-recovery";
            patch = ./patches/981-mtk-eth-do-not-reset-all-macs-on-tx-timeout.patch;
          }
          # Warm-reset poll fix for MT7988: the FE clears RSTCTRL_FE
          # asynchronously, so polling for the asserted bit times out on every
          # recovery attempt and the cold-reset fallback leaves the MACs down
          # ("warm reset failed", total outage until reboot).  Poll for the
          # deasserted state instead (OpenWrt mtk_eth_soc form).
          {
            name = "mtk-eth-warm-reset-poll-fix";
            patch = ./patches/982-mtk-eth-warm-reset-fix.patch;
          }
          # Warm reboot hangs on this board.  arm64 machine_restart() calls
          # efi_reboot() first, and U-Boot's EFI runtime advertises
          # EFI_RT_SUPPORTED_RESET_SYSTEM, so efi.reset_system() is trusted to
          # reset the SoC -- which it does not do reliably -- and the PSCI
          # restart handler behind it is never reached.  Run the restart chain
          # first and keep EFI as the fallback.  `efi=no_runtime` does not help:
          # the kernel still remaps EFI services (dmesg: "Remapping and enabling
          # EFI services").
          {
            name = "arm64-restart-before-efi";
            patch = ./patches/983-arm64-restart-before-efi.patch;
          }
        ];
        structuredExtraConfig =
          (prev.structuredExtraConfig or { })
          // (with lib.kernel; {
            # --- watchdog ---
            # mtk_wdt is BUILTIN here (modules.builtin, no .ko), and its
            # `nowayout` parameter defaults to WATCHDOG_NOWAYOUT, a build-time
            # symbol -- /sys/module/mtk_wdt/parameters/ is empty, so neither a
            # modprobe.d option NOR a kernel command line can set it.  Turn it
            # on at compile time: without it systemd's "watchdog did not stop!"
            # path leaves MT7988's TOPRGU with nothing kicking it and a warm
            # reboot hangs until the board is power-cycled.
            WATCHDOG_NOWAYOUT = yes;

            # --- board networking drivers (the delta provides the code) ---
            NET_MEDIATEK_SOC = module;
            NET_MEDIATEK_SOC_WED = yes;
            NET_DSA = module;
            NET_DSA_MXL862 = module;
            NET_DSA_TAG_MXL_862XX = module;
            NET_DSA_TAG_MXL_862XX_8021Q = module;
            PCS_MTK_LYNXI = yes;
            PCS_MTK_USXGMII = yes;
            FWNODE_PCS = yes;
            PHY_COMMON_PROPS = yes;
            # 2.5G/10G PHYs used by the board
            MEDIATEK_2P5GE_PHY = module;
            MAXLINEAR_GPHY = module;
            # SFP cage support (sfp1 = LAN, sfp2 = WAN)
            SFP = module;
            # nixpkgs' common-config enables DAMON + all its sub-options.  DAMON's
            # reclaim/stat engines run kdamond continuously (~22% of a core here),
            # scanning and reclaiming memory and competing with kswapd.  Keep DAMON
            # itself on (its sub-options are only valid when it is, and disabling it
            # makes them "unused" and fails the config check), but turn off the
            # engines that actually burn CPU.
            DAMON_RECLAIM = lib.mkForce no;
            DAMON_LRU_SORT = lib.mkForce no;
            DAMON_STAT = lib.mkForce no;

            # NOTE on pruning sound/DRM/media: `SND = lib.mkForce no` and
            # friends do NOT work here, so don't "fix" them back in.  Those
            # are tristate symbols not mentioned by common-config, and
            # nixpkgs' builder runs generate-config.pl with AUTO_MODULES=true,
            # which answers `m` for every tristate question whose prompt leads
            # with m (generate-config.pl:94) -- overriding the resolved
            # answer.  DAMON_RECLAIM above survives only because it is a bool.
            # Pruning a tristate tree needs its bool gate to be off, or
            # autoModules = false, which is a much larger change than it looks
            # (it stops building virtually every module).
          });

        # Drop the kernel tree's device trees from the build and install
        # targets.  On aarch64 `build.nix` defaults `buildDTBs` to true, which
        # puts `dtbs` in buildFlags and `dtbs_install` in installFlags; with
        # CONFIG_ARCH_{QCOM,ROCKCHIP,TEGRA,EXYNOS,SUNXI,BCM,MESON,MVEBU,
        # RENESAS,APPLE,HISI,STM32,...} all =y (they arrive from
        # common-config) that is 1570 DTBs / ~118M in the kernel output, none
        # of which this board can boot.
        #
        # The one DTB we need is the self-contained
        # mt7988a-bananapi-bpi-r4-pro-4e-sd.dts, compiled directly with dtc in
        # ./default.nix (`dtbSource`) -- see the rationale there.  Nothing in
        # the board module reads the kernel's dtbs/ output; `dtbSource` is its
        # own derivation.
        #
        # This has to be `overrideAttrs` and not a `buildDTBs = false` arg:
        # on the cross set (`pkgsCross.aarch64-multiplatform`) that argument is
        # silently dropped -- `generic.nix` forwards it only when non-null and
        # `build.nix` re-derives its default from the host platform, so the
        # attribute never reaches the resulting package (verified: it is
        # absent from `pkg.buildDTBs` and `dtbs` was still in `buildFlags`).
        # buildFlags/installFlags are final attributes, so filtering them here
        # is what actually takes effect.
      })).overrideAttrs
        (prev: {
          buildFlags = builtins.filter (f: f != "dtbs") prev.buildFlags;
          installFlags = builtins.filter (f: f != "dtbs_install") prev.installFlags;

          # State the policy, don't just delete the target.  nixpkgs' kernel
          # derivation does NOT expose `buildDTBs` unless the caller passes it
          # (`generic.nix` only `inherit`s it when non-null, and there the default
          # is null), so on a normal kernel the attribute is simply MISSING.
          # That matters because `hardware.deviceTree.enable` DEFAULTS to
          # `config.boot.kernelPackages.kernel.buildDTBs`:
          #
          #   enable = lib.mkOption { default = config.boot.kernelPackages.kernel.buildDTBs; }
          #
          # so any board that leaves `hardware.deviceTree.enable` unset throws
          # "attribute 'buildDTBs' missing" the moment the boot module reads it.
          # Setting it here makes the attribute well-defined and false, i.e. "no,
          # this kernel builds no DTBs", and the nixpkgs default then resolves to
          # a clean `false` instead of an eval error.
          #
          # NOTE the polarity: this is the KERNEL's answer, not the board's.  The
          # board still needs a device tree installed for the bootloader -- it
          # just comes from `dtbSource` (dtc on ./dtb/*.dts), not the kernel
          # tree -- so ./default.nix keeps `hardware.deviceTree.enable = true`.
          # The two are independent; nixpkgs coupling them via this default is
          # the bug, and it only looks correct on a stock aarch64 kernel because
          # there buildDTBs happens to be true.
          buildDTBs = false;
        })
    )
  );
}

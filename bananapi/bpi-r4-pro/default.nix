{
  config,
  lib,
  pkgs,
  ...
}:

# Banana Pi BPI-R4 Pro (MediaTek MT7988A, aarch64).
#
# Board support only: device tree, console, kernel and boot-chain policy.  It
# deliberately does NOT own the root filesystem, users, or networking -- those
# belong to the consuming host.
#
# The 4E variant is the populated board used in this repo's fleet (s-nodus):
# a single 1G internal-switch jack, four 2.5G MxL86252 copper jacks, one 10G
# SFP+ LAN, one 2.5G RJ45 / 10G SFP+ WAN combo.  See ./dtb for the port map.
#
# Boot chain (the board's stock OpenWrt U-Boot, read verbatim from the vendor
# FIP blob):
#
#   cold power-on
#     -> MTK BootROM -> BL2 (SD sector 34)
#     -> BL2 reads the GPT and loads the ARM-TF FIP from the partition NAMED
#        "fip"  (if absent: "Partition 'fip' not found" -> "System halt!")
#     -> BL31 + BL33/U-Boot
#     -> bootcmd = run boot_sdmmc
#        boot_sdmmc = run boot_production ; run boot_recovery
#        boot_production = ... sdmmc_read_production && bootm $loadaddr#$bootconf#$bootconf_sd#$bootconf_extra
#        sdmmc_read_production: `part start mmc 0 production`, read the FIT raw
#          from offset 0 of that partition, `imszb` it, check size <= part_size
#     -> NixOS
#
# NixOS does NOT own the bootloader on this board: no systemd-boot, no EFI (the
# vendor U-Boot's default env contains no bootefi/BOOTAA64 path).  The FIT is
# produced by ./fit.nix and written into the `production` partition by
# ./sd-image.nix (or the fit-sync unit for upgrades).
let
  cfg = config.hardware.bananapi.bpi-r4-pro;

  # The boot chain (BL2/BL31/U-Boot) is AArch64 firmware.  Build it with the
  # cross set so an x86_64 evaluation host produces aarch64 blobs, and so an
  # aarch64 host builds them natively.
  pkgsCross =
    if pkgs.stdenv.hostPlatform.isAarch64 then pkgs else pkgs.pkgsCross.aarch64-multiplatform;
in
{
  imports = [
    ./linux.nix
    ./fip.nix
    ./smc/reboot.nix
    ./efi.nix
  ];

  options.hardware.bananapi.bpi-r4-pro = {
    enable = lib.mkEnableOption "Banana Pi BPI-R4 Pro (MT7988A) board support";

    extraKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra kernel parameters appended to the board bootargs (both the FIT's
        /chosen bootargs and the U-Boot env written into the `ubootenv`
        partition).
      '';
    };

    kernelCheck = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Keep the MT7988 ethernet + DSA drivers in the build closure, so a
        nixpkgs/kernel bump cannot silently drop them.  Without them the board
        boots with no netdev at all, and the only way back in is the serial
        console.
      '';
    };

    buildFirmware = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Build the board's own BL2 and FIP (BL31 + U-Boot) instead of relying on
        the signed vendor OpenWrt firmware.  Enables an EFI boot chain: U-Boot
        with `CONFIG_EFI_LOADER`, then stock systemd-boot on an ESP.

        The vendor firmware could only `bootm` a raw FIT, which forced an
        absolute `init=` into the image and made switching NixOS generations
        impossible -- a rebuilt profile was ignored until the FIT was reflashed.
      '';
    };

    atfPackage = lib.mkOption {
      type = lib.types.package;
      # Built with GCC 13, the compiler major OpenWrt used for the known-good
      # mt7988-sdmmc-comb preloader (toolchain/gcc/Config.version in 24.10).
      #
      # `overrideCC` does NOT work here: on a cross package set it re-uses the
      # native compiler and silently returns the same store path as the GCC 15
      # build.  `gcc13Stdenv` rebuilds the cross stdenv itself, which is what
      # actually changes the aarch64 code generator (15.3.0 -> 13.4.0).
      default = pkgsCross.callPackage ./atf.nix { stdenv = pkgsCross.gcc13Stdenv; };
      defaultText = lib.literalMD "the board's pinned MT7988 ATF derivation (GCC 13)";
      description = ''
        The ARM Trusted Firmware build (BL2 preloader + BL31 monitor).
      '';
    };

    ubootPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgsCross.callPackage ./uboot.nix { };
      defaultText = lib.literalMD "the board's pinned U-Boot derivation";
      description = ''
        The U-Boot (BL33) build.  Must be built for aarch64 with
        `CONFIG_EFI_LOADER` enabled, see ./uboot.nix.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # --- device tree ----------------------------------------------------
    # We ship a SELF-CONTAINED board DTS and compile it directly with dtc,
    # instead of building it from the kernel source.  Two reasons:
    #
    #   1. The board DTS only landed upstream in Linux 6.19, and we run the
    #      6.18 board kernel (./linux.nix) for its MT7988 USXGMII/SerDes +
    #      MxL86252 support -- so the kernel source has no 4E DTS.
    #   2. The mainline 6.19 board dtsi does not compile against the 6.18
    #      mt7988a.dtsi (symbol drift, e.g. ssusb0).  A resolved, self-contained
    #      DTS sidesteps all of that.
    #
    # Provenance of ./dtb/mt7988a-bananapi-bpi-r4-pro-4e-sd.dts: `dtc -I dtb -O
    # dts` of the resolved tree (mainline board dtsi + the lan-port-map fragment
    # + the mainline SD overlay) that already runs on the hardware, frozen into
    # one file.  It carries the board fixes: internal switch port 0 only,
    # MxL86252 in MAINLINE port numbering (copper 1..4, CPU 9, SFP 13), firmware
    # 1.0.85.
    # The board NEEDS a device tree, but does NOT need the kernel to build one:
    # ./linux.nix turns the kernel's `buildDTBs` off explicitly (1570 DTBs for
    # every SoC common-config enables, 118M, and none of them is this board --
    # the bpi-r4-pro DTS only landed upstream in 6.19 while we run 6.18).
    #
    # Do not let `enable` fall back to its nixpkgs default, which is
    # `config.boot.kernelPackages.kernel.buildDTBs`: that couples two unrelated
    # questions ("does the kernel build DTBs?" vs "does this board need a DTB
    # installed?").  Here the answers differ, so state the board's answer
    # explicitly.  `dtbSource` is a plain dtc runCommand, independent of the
    # kernel package.
    hardware.deviceTree = {
      enable = lib.mkDefault true;
      name = lib.mkDefault "mediatek/mt7988a-bananapi-bpi-r4-pro-4e-sd.dtb";
      dtbSource = lib.mkDefault (
        pkgs.runCommand "bpi-r4-pro-dtbs"
          {
            nativeBuildInputs = [ pkgs.dtc ];
          }
          ''
            mkdir -p $out/mediatek
            dtc -I dts -O dtb -o "$out/mediatek/mt7988a-bananapi-bpi-r4-pro-4e-sd.dtb" \
              ${./dtb/mt7988a-bananapi-bpi-r4-pro-4e-sd.dts}
          ''
      );
    };

    # --- kernel build guard ---------------------------------------------
    # The headline cause of an unreachable board on this setup was kernel/module
    # DRIFT (the boot FIT carrying a different kernel than the generation's
    # --- out-of-tree module building ------------------------------------
    # Expose the kernel's `dev` output (headers + build scripts + generated
    # config) so a module can be compiled in seconds instead of triggering a
    # full kernel rebuild:
    #
    #   make -C $(nix build .#..kernel.dev --print-out-paths)/lib/modules/*/build \
    #        M=$PWD modules && insmod ./foo.ko
    #
    # NixOS installs only `kernel-modules` (the .ko files), so without this
    # /lib/modules/<ver>/build does not exist and every module experiment costs
    # a full nixos-rebuild.
    #
    # The path is stable across generations that share a kernel, and insmod
    # refuses a module built against a different version (version magic
    # mismatch), so a stale dev output fails safe rather than crashing.
    environment.etc."kernel-dev/source".source = config.boot.kernelPackages.kernel.dev;

    # `kernel-modules`; ./fit.nix keeps them in sync).  This guard is the
    # complementary check: it fails the build if the kernel's modules tree does
    # not carry the MT7988 ethernet + MT7530 DSA drivers at all.
    system.extraDependencies = lib.optional cfg.kernelCheck (
      pkgs.runCommand "bpi-r4-pro-kernel-mt7988-net-check"
        {
          nativeBuildInputs = [ pkgs.xz ];
          modules = config.boot.kernelPackages.kernel.modules;
        }
        ''
          found_eth=0
          found_dsa=0
          while IFS= read -r f; do
            case "$f" in
              */drivers/net/ethernet/mediatek/mtk_eth.ko*) found_eth=1 ;;
              */drivers/net/dsa/mt7530.ko*) found_dsa=1 ;;
            esac
          done < <(find "$modules" -type f -o -type l)
          if [ "$found_eth" != 1 ] || [ "$found_dsa" != 1 ]; then
            echo "ERROR: kernel modules tree lacks MT7988 ethernet/DSA drivers" >&2
            echo "  mtk_eth found: $found_eth  mt7530 found: $found_dsa" >&2
            echo "  modules: $modules" >&2
            exit 1
          fi
          touch "$out"
        ''
    );

    # --- console / bootargs ---------------------------------------------
    # ttyS0 @ 115200 8N1 (confirmed on a live boot).
    #
    # clk_ignore_unused / pd_ignore_unused: keep "unused" clocks and power
    # domains on.  On MT7988 the MTK net drivers probe late; with
    # clk_disable_unused/genpd having gated their block a register access
    # hangs the CPU (rcu_sched stall -> hard LOCKUP -> boot wedge).  These flags
    # prevent that gating.
    #
    # NOTE: the authoritative bootargs on this board come from the U-Boot env
    # (./uboot-env.nix); these kernelParams feed the FIT's /chosen/bootargs and
    # a direct `bootm` without the env.
    boot.kernelParams = lib.mkBefore [
      "console=ttyS0,115200n1"
      "clk_ignore_unused"
      "pd_ignore_unused"

      # Do NOT use the EFI runtime services for restart/poweroff.
      #
      # Booting through systemd-boot means the kernel is entered as an EFI
      # application, so it installs an EFI reset handler: machine_restart()
      # calls ResetSystem() through U-Boot's runtime services instead of the
      # PSCI call that used to reach BL31 directly.  That chain is what hangs
      # on this board -- `systemctl reboot` and `poweroff` both stop dead,
      # while the same FIP powered off fine under the old FIT path, where the
      # kernel came straight from `bootm` and never saw EFI runtime.
      #
      # efi=no_runtime drops the EFI runtime mapping, so restart and poweroff
      # go back to PSCI -> BL31, which is the path that works.
      "efi=no_runtime"
    ];

    # `kernel.dmesg_restrict = 1` means an ordinary operator account gets ZERO
    # lines from dmesg, which is backwards for a board that is diagnosed over
    # ssh.
    boot.kernel.sysctl."kernel.dmesg_restrict" = lib.mkDefault 0;

    # The DT reserves only 64 KiB of ramoops at 0x42ff0000 and the pstore
    # CONSOLE backend fills it with ordinary console output, leaving no room for
    # the oops record itself (ENOSPC on a panic).  Drop the console backend to
    # keep the zone for dmesg/oops records.
    # Drop the pstore console backend (see the ramoops note above) AND keep the
    # MT7988 watchdog armed across a reboot.
    #
    # `systemctl reboot` reaches
    #   [  OK  ] Reached target System Reboot.
    #   watchdog: watchdog0: watchdog did not stop!
    #   [  424.301714] reboot: Restarting system
    # and then the SoC never comes back: a power cycle is needed.
    #
    # mtk_wdt already drives MT7988's TOPRGU on 6.18 (including the
    # WDT_SWSYSRST_EN bit at 0xfc that MT7988 needs before a software reset is
    # honoured) and the board DTS enables mediatek,mt7988-wdt, so the reset
    # path exists -- it simply never fires because systemd closes the watchdog
    # while shutting down.
    #
    # `nowayout=1` keeps it armed once started, which is what actually performs
    # the reset.
    #
    # NOTE: boot.extraModprobeConfig cannot be set from this module --
    # nixos/modules/tasks/network-interfaces.nix assigns it unconditionally
    # ("options bonding max_bonds=0"), which beats both mkDefault and a mkForce
    # inside this mkIf block (verified: the definition never reaches the merge).
    # modprobe.d is therefore written through environment.etc instead, and the
    # systemd watchdog windows below keep kicking the timer through shutdown.
    # mtk_wdt is BUILTIN here and exposes NO /sys/module parameters: its
    # `nowayout` is set from the build-time symbol WATCHDOG_NOWAYOUT, so neither
    # modprobe.d nor the kernel command line can reach it.  The switch is made
    # in ./linux.nix (WATCHDOG_NOWAYOUT = yes).  Measured before that:
    #
    #   mtk-wdt 1001c000.watchdog: Watchdog enabled (timeout=31 sec, nowayout=0)
    #
    # ramoops, by contrast, IS a module, so its option belongs in modprobe.d.
    environment.etc."modprobe.d/bpi-r4-pro-watchdog.conf".text = lib.mkForce ''
      options ramoops console_size=0
    '';

    systemd.settings.Manager = {
      RuntimeWatchdogSec = lib.mkDefault "30s";
      RebootWatchdogSec = lib.mkDefault "2min";
      KExecWatchdogSec = lib.mkDefault "2min";
    };

    # The serial console must ALWAYS exist: it is the only way onto this board
    # when the network is down, which happens regularly.
    #
    # `serial-getty@ttyS0` is normally instantiated by systemd-getty-generator
    # only when `console=ttyS0` appears on the KERNEL COMMAND LINE.  On this
    # board that command line comes from the U-Boot env, not from NixOS's
    # boot.kernelParams -- so if an env is flashed whose bootargs lack the
    # console argument, no serial getty is ever spawned and the board becomes
    # unreachable exactly when the console matters most.  Pulling the instance in
    # through getty.target makes it independent of the bootargs.
    systemd.targets.getty.wants = [ "serial-getty@ttyS0.service" ];

    # --- initrd ---------------------------------------------------------
    # NVMe root needs the mtk-pcie-gen3 host controller (built-in in the board
    # kernel); the SD fallback needs mmc host + the card filesystems.
    #
    # `availableKernelModules` only means "the initrd ships it"; it does not
    # make stage 1 WAIT for the device.  Measured on hardware: the NVMe only
    # appeared at ~36 s, after systemd had already tried sysroot-nix.mount and
    # given up --
    #
    #   Dependency failed for /sysroot/nix.
    #   Dependency failed for Find NixOS closure.
    #
    # -- even though the same mount succeeded by hand seconds later.  The
    # modules are therefore pinned into the initrd with `initrd.kernelModules`
    # so they are loaded unconditionally and early, and the PCIe controller is
    # brought up before the mount units are queued.
    boot.initrd.availableKernelModules = [
      "mmc_block"
      "sd_mod"
      "nvme"
      "nvme_core"
      "pcie-mediatek-gen3"
      "phy-mtk-pcie"
      "usb_storage"
      "uas"
    ];

    # Load order matters more than availability: without these the NVMe device
    # node does not exist when systemd-fstab-generator's units start.
    boot.initrd.kernelModules = [
      "nvme"
      "nvme_core"
      "pcie-mediatek-gen3"
      "phy-mtk-pcie"
    ];

    # --- bootloader -----------------------------------------------------
    # NixOS OWNS the bootloader on this board: ./efi.nix installs systemd-boot
    # on an ESP and U-Boot (built with CONFIG_EFI_LOADER in ./uboot.nix) boots
    # it.  The vendor OpenWrt firmware could only `bootm` a raw FIT and is no
    # longer used -- see ./fip.nix.
    #
    # The old code force-disabled every loader here because the vendor U-Boot
    # had no EFI path.  That assumption is what this change removes, so the
    # disable block is gone; ./efi.nix sets the loaders explicitly.
    boot.loader.efi.canTouchEfiVariables = lib.mkForce false; # no EFI vars on this board
  };
}

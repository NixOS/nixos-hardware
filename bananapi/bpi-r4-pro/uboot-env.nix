{
  config,
  lib,
  pkgs,
  ...
}:

# Write the U-Boot environment into the board's `ubootenv` partition.
#
# WHY THIS IS NOW TINY
# --------------------
# While the board booted a raw FIT, this file had to reproduce the whole vendor
# OpenWrt SD boot path (`sdmmc_read_production`, `bootconf*`, `bootm
# $loadaddr#...`) AND carry the kernel command line, because U-Boot's
# image_setup_libfdt() overwrites /chosen/bootargs from `env_get("bootargs")`.
# That made the environment the only place `init=` could live, and it had to
# point at a generation.
#
# With U-Boot booting the ESP, the kernel command line belongs to each
# systemd-boot entry -- `nixos-rebuild boot` writes it, per generation.  So the
# environment only has to do one thing: find the ESP and boot it.  U-Boot's
# `bootstd` scanner already does that (`bootflow scan -lb`, set in
# ./uboot.nix's CONFIG_BOOTCOMMAND), so this only has to exist so that a broken
# environment cannot send the board somewhere useless.
#
# bootargs is still written, deliberately: if bootstd ever falls back to a
# manual `booti`/`bootm`, these are the parameters that make the kernel find the
# root and the console.  They are NOT authoritative for a normal boot.
let
  cfg = config.hardware.bananapi.bpi-r4-pro;

  envText = pkgs.writeText "bpi-r4-pro-uboot-env.txt" ''
    # Boot the ESP: U-Boot scans block devices for /EFI/BOOT/BOOTAA64.EFI,
    # then systemd-boot shows the generation menu on the serial console.
    bootcmd=bootflow scan -lb

    bootdelay=2
    bootmenu_default=0
    bootmenu_delay=2
    bootmenu_title=BPI-R4 Pro NixOS
    bootmenu_0=Boot NixOS from the ESP.=run bootcmd
    bootmenu_1=U-Boot console.=exit

    # Fallback parameters for a manual boot from the U-Boot console.  A normal
    # boot gets its command line from the systemd-boot entry instead.
    #
    # init= is mandatory for NixOS's systemd initrd (initrd-find-nixos-closure
    # resolves it inside /sysroot).  The stable profile symlink is used so it
    # cannot go stale after an on-board rebuild.
    # `root=fstab` (NOT root=PARTLABEL=...): fileSystems."/" already carries
    # x-initrd.mount, so a root= device as well would make
    # systemd-fstab-generator try to create sysroot.mount twice and bail out,
    # leaving /persist (and the sops age key) unmounted in the initrd.
    bootargs=${
      lib.concatStringsSep " " (
        [
          "console=ttyS0,115200n1"
          "pci=pcie_bus_perf"
          "clk_ignore_unused"
          "pd_ignore_unused"
          "root=fstab"
          "rootwait"
          "rw"
          "init=/nix/var/nix/profiles/system/init"
        ]
        ++ cfg.extraKernelParams
      )
    }

    # Serial console must survive a bad env: these make `booti` usable by hand.
    kernel_addr_r=0x46000000
    fdt_addr_r=0x45f00000
    ramdisk_addr_r=0x4a000000
  '';
in
{
  config = lib.mkIf cfg.enable {
    # Redundant env: two 0x40000 copies, matching what U-Boot expects and what
    # the `ubootenv` partition is sized for.
    system.build.bpiR4ProUbootEnv =
      pkgs.runCommand "bpi-r4-pro-uboot-env.bin"
        {
          nativeBuildInputs = [
            (if pkgs.stdenv.buildPlatform.isAarch64 then pkgs.ubootTools else pkgs.pkgsBuildBuild.ubootTools)
          ];
        }
        ''
          mkenvimage -s 0x40000 -r -o "$out" ${envText}
        '';
  };
}

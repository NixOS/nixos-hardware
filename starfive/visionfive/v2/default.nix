{ config, lib, pkgs, ... }: {
  boot = {
    # Force no ZFS (from nixos/modules/profiles/base.nix) until updated to kernel 6.0
    supportedFilesystems =
      lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault (pkgs.callPackage ./linux-6.6.nix {
      inherit (config.boot) kernelPatches;
    });

    kernelParams =
      lib.mkDefault [ "console=tty0" "console=ttyS0,115200n8" "earlycon=sbi" ];

    initrd.availableKernelModules = [ "dw_mmc_starfive" ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };
}

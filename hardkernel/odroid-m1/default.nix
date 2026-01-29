{ config, pkgs, lib, ... }:

{
  imports = [
    ./petitboot
  ];

  boot.loader.petitboot.enable = lib.mkForce true;

  # Fails to rebuild unless grub is explicitly disabled
  boot.loader.grub.enable = lib.mkForce false;

  # TODO: Can this be removed? Presumably anything built with 25.11 / unstable
  #       or later will be on a kernel >6.6
  # Use kernel >6.6 The devicetree is missing from kernel versions older than this.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.6") (lib.mkDefault pkgs.linuxPackages_latest);

  # TODO: Debug why removing this breaks booting from petitboot
  boot.supportedFilesystems = lib.mkForce [
    "btrfs"
    "cifs"
    "f2fs"
    "jfs"
    "ntfs"
    "reiserfs"
    "vfat"
    "xfs"
  ];

  # TODO: Some of these could potentially be omitted, check which ones are
  #       actually necessary for disk access to function
  boot.initrd.availableKernelModules = [
    # Only nvme emitted when using nixos-generate-config on my odroid-m1
    "nvme"
    # "nvme-core"
    # "phy-rockchip-naneng-combphy"
    # "phy-rockchip-snps-pcie3"
  ];

  # Petitboot uses this port and baud rate on the board's serial port. It's
  # probably good to keep the options same for the running kernel for serial
  # console access to work well.
  boot.kernelParams = [ "console=ttyS2,1500000" ];
  hardware.deviceTree.name = "rockchip/rk3568-odroid-m1.dtb";
}

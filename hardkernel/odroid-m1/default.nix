# Based on kboot-conf by original authors povik and sstent.
# I'm just porting things over. the original work can be viewed at:
# https://github.com/sstent/nixos-on-odroid-m1 
# https://github.com/povik/nixos-on-odroid-n2
{ config, pkgs, lib, ... }:

{
  imports = [
    ./kboot-conf
  ];

  #boot.loader.grub.enable = false;
  boot.loader.kboot-conf.enable = true;
  # Use kernel >6.6 The devicetree is missing from kernel versions older than this.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.6") (lib.mkDefault pkgs.linuxPackages_latest);

  # I'm not completely sure if some of these could be omitted,
  # but want to make sure disk access works
  boot.initrd.availableKernelModules = [
    "nvme"
    "nvme-core"
    "phy-rockchip-naneng-combphy"
    "phy-rockchip-snps-pcie3"
  ];
  
  # Petitboot uses this port and baud rate on the boards serial port,
  # it's probably good to keep the options same for the running
  # kernel for serial console access to work well
  boot.kernelParams = ["console=ttyS2,1500000"];
  hardware.deviceTree.name = "rockchip/rk3568-odroid-m1.dtb";
}

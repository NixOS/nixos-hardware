{ pkgs, lib, ... }:
{
  boot.initrd.kernelModules = [
    # PCIe/NVMe
    "nvme"
    "pcie_rockchip_host"
    "phy_rockchip_pcie"
  ];
}

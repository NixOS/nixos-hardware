{ lib, ... }:

{
  imports = [ ../ts-x33 ];

  # The PCIe AHCI controller serves drive bays 3 and 4.
  boot.initrd.availableKernelModules = [ "ahci" ];

  hardware = {
    deviceTree.name = lib.mkDefault "rockchip/rk3568-qnap-ts433.dtb";
    # The RTL8125B 2.5GbE controller can use firmware from linux-firmware.
    enableRedistributableFirmware = lib.mkDefault true;
  };
}

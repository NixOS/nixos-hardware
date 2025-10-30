{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/haswell
    ../../../common/pc/laptop
  ];

  hardware.enableAllFirmware = lib.mkDefault true;

  services = {
    fwupd.enable = lib.mkDefault true;
    thermald.enable = lib.mkDefault true;
  };
}

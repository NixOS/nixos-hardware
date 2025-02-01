{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/gpu/intel/haswell
  ];

  hardware.enableAllFirmware = lib.mkDefault true;

  services = {
    fwupd.enable = lib.mkDefault true;
    thermald.enable = lib.mkDefault true;
  };

  boot = {
    # needs to be explicitly loaded or else bluetooth/wifi won't work.
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };
}

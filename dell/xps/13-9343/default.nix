{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  services = {
    fwupd.enable = lib.mkDefault true;
    thermald.enable = lib.mkDefault true;
  };

  boot = {
    # needs to be explicitly loaded or else bluetooth/wifi won't work
    kernelModules = [
      "kvm-intel"
      "wl"
    ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };
}

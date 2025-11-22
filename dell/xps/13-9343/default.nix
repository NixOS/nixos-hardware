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
    kernelModules = [
      "kvm-intel"
    ];
  };
}

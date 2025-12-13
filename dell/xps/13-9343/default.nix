{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/broadcom-wifi.nix
  ];

  config = {
    boot.kernelModules = [
      "kvm-intel"
    ];

    services = {
      fwupd.enable = lib.mkDefault true;
      thermald.enable = lib.mkDefault true;
    };
  };
}

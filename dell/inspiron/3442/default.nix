{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/haswell
    ../../../common/pc/laptop
    ../../../common/broadcom-wifi.nix
  ];

  config = {
    services = {
      fwupd.enable = lib.mkDefault true;
      thermald.enable = lib.mkDefault true;
    };
  };
}

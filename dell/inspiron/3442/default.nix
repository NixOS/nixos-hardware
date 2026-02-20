{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/haswell
    ../../../common/pc/laptop
  ];

  services = {
    fwupd.enable = lib.mkDefault true;
    thermald.enable = lib.mkDefault true;
  };
}

{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/broadwell
    ../../../common/pc
    ../../../common/pc/ssd
  ];

  services.thermald.enable = lib.mkDefault true;
}

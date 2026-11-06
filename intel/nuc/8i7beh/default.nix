{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/coffee-lake
    ../../../common/pc
    ../../../common/pc/ssd
  ];

  services.thermald.enable = lib.mkDefault true;
}

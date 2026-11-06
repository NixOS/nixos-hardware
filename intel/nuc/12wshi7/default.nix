{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/alder-lake
    ../../../common/pc
    ../../../common/pc/ssd
  ];

  services.thermald.enable = lib.mkDefault true;
}

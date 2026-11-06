{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc
    ../../../common/pc/ssd
  ];

  services.thermald.enable = lib.mkDefault true;
}

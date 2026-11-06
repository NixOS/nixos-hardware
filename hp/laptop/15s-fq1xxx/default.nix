{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/ice-lake
    ../../../common/pc
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  config = {
    services.thermald.enable = lib.mkDefault true;
  };
}

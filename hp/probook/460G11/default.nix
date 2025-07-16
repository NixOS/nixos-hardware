{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/meteor-lake
    ../../../common/pc
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  config = {
    services.thermald.enable = lib.mkDefault true;
  };
}

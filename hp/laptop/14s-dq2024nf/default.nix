{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/tiger-lake
    ../../../common/pc
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  config = {
    services.thermald.enable = lib.mkDefault true;
  };
}

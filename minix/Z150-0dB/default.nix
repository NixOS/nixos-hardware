{ config, lib, ... }:
{
  imports = [
    ../../common/cpu/intel/alder-lake
    ../../common/pc
    ../../common/pc/ssd
  ];

  config = {
    services.thermald.enable = lib.mkDefault true;
  };
}

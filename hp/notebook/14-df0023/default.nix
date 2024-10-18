{ config, lib, ... }:
with lib;
{
  imports = [
    ../../../common/cpu/intel/sandy-bridge
    ../../../common/pc
    ../../../common/pc/laptop
    ../../../common/pc/laptop/hdd
  ];

  config = {
    services.thermald.enable = mkDefault true;
  };
}

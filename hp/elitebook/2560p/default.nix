{ config, lib, pkgs, ... }:
with lib;
let
  xcfg = config.services.xserver;
in
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/cpu/intel/sandy-bridge
    ../../../common/pc
    ../../../common/pc/laptop
    ../../../common/pc/laptop/hdd
    ../../../common/pc/hdd

    ./network.nix
  ];

  config = {
    services.thermald.enable = mkDefault true;
  };
}

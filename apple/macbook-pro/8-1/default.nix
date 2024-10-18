{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel/sandy-bridge
    ../../../common/pc/laptop/ssd
  ];

  networking.enableB43Firmware = lib.mkDefault true;
}

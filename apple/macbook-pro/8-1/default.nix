{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/gpu/intel/sandy-bridge
    ../../../common/pc/laptop/ssd
  ];

  networking.enableB43Firmware = lib.mkDefault true;
}

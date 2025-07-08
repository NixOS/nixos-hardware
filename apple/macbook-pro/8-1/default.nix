{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../.
    ../../../common/cpu/intel/sandy-bridge
    ../../../common/pc/ssd
  ];

  networking.enableB43Firmware = lib.mkDefault true;
}

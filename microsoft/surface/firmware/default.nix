{ config, lib, pkgs, ... }:
{
  hardware.enableAllFirmware = true;
  hardware.firmware = [
    (pkgs.callPackage ./ipts.nix {})
  ];
}

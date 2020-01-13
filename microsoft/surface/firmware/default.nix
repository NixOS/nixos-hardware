{ config, lib, pkgs, ... }:
{
  hardware.enableAllFirmware = true;
  hardware.firmware = [
    (pkgs.callPackage ./ath10k.nix {})
    # (pkgs.callPackage ./ipts.nix {})
  ];
}

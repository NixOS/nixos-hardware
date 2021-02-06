{ config, lib, pkgs, ... }:
{
  hardware.enableAllFirmware = true;
  hardware.firmware = [
    # TODO: Wrap with an option:
    (pkgs.callPackage ./ath10k.nix {})
  ];
}

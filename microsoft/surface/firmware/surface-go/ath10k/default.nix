{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.microsoft-surface.firmware.surface-go-ath10k;
in
{
  options = {
    hardware.microsoft-surface.firmware.surface-go-ath10k = {
      enable = lib.mkEnableOption ''Use the "board.bin" firmware for ath10k-based WiFi on Surface Go.'';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.enableAllFirmware = true;
    hardware.firmware = [
      (pkgs.callPackage ./ath10k.nix {})
    ];
  };
}

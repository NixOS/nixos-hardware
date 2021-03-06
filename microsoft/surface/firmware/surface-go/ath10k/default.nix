{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.microsoft-surface.firmware.surface-go-ath10k;
in
{
  options = {
    hardware.microsoft-surface.firmware.surface-go-ath10k = {
      replace = lib.mkEnableOption ''Use the "board.bin" firmware for ath10k-based WiFi on Surface Go.'';
    };
  };

  config = lib.mkIf cfg.replace {
    hardware.enableAllFirmware = true;
    hardware.firmware = [
      (pkgs.callPackage ./ath10k-replace.nix {})
    ];

    boot.extraModprobeConfig = lib.mkDefault ''
      options ath10k_core skip_otp=Y
    '';
  };
}

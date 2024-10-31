{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.hardware.microsoft-surface.firmware.surface-go-ath10k;

in {
  options = {
    hardware.microsoft-surface.firmware.surface-go-ath10k = {
      replace = mkEnableOption ''Use the "board.bin" firmware for ath10k-based WiFi on Surface Go.'';
    };
  };

  config = mkIf cfg.replace {
    warnings = [''A working version of the ath10k QCA6174 firmware has been added to the kernel.org linux-firmware
                  repo, making this fix obsolete.
                  See:
                  -  https://github.com/linux-surface/linux-surface/issues/542#issuecomment-976995453
                  - https://github.com/linux-surface/linux-surface/wiki/Surface-Go#wi-fi-firmware

                  NOTE: This module option will probably be removed in the near future.
    ''];

    hardware.enableAllFirmware = true;
    hardware.firmware = [
      (pkgs.callPackage ./ath10k-replace.nix {})
    ];

    boot.extraModprobeConfig = mkDefault ''
      options ath10k_core skip_otp=Y
    '';
  };
}

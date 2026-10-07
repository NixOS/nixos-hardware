{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi.audio;
in
{
  imports = [ ./config-txt.nix ];

  options.hardware.raspberry-pi.audio = {
    enable = lib.mkEnableOption "legacy onboard audio on Raspberry Pi 2, 3, and 4";
    hdmi.enable = lib.mkEnableOption "snd_bcm2835 HDMI audio for FKMS or the legacy display stack";
  };

  config = lib.mkIf cfg.enable {
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
    boot.kernelModules = [ "snd_bcm2835" ];
    boot.kernelParams = [
      "snd_bcm2835.enable_headphones=1"
      "snd_bcm2835.enable_hdmi=${if cfg.hdmi.enable then "1" else "0"}"
    ];

    hardware.raspberry-pi.configtxt.settings = lib.genAttrs [ "pi2" "pi3" "pi4" ] (_: {
      dtparam = [ "audio=on" ];
    });
  };
}

{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.raspberry-pi."4".audio;
in
{
  options.hardware = {
    raspberry-pi."4".audio = {
      enable = lib.mkEnableOption ''
        configuration for audio
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.deviceTree = {
      overlays = [
        # Equivalent to dtparam=audio=on
        {
          name = "audio-on-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;
            / {
              compatible = "brcm,bcm2711";
              fragment@0 {
                target = <&audio>;

                __overlay__ {
                  status = "okay";
                };
              };
            };
          '';
        }
      ];
    };
  };
}


{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.raspberry-pi."4".pwm0;
in
{
  options.hardware = {
    raspberry-pi."4".pwm0 = {
      enable = lib.mkEnableOption ''
        Enable support for the hardware pwm0 channel on GPIO_18
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.deviceTree = {
      overlays = [{
        name = "pwm-overlay";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          / {
            compatible = "brcm,bcm2711";

            fragment@0 {
              target = <&gpio>;
              __overlay__ {
                pwm_pins: pwm_pins {
                  brcm,pins = <18>;
                  brcm,function = <2>; /* Alt5 */
                };
              };
            };

            fragment@1 {
              target = <&pwm>;
              __overlay__ {
                pinctrl-names = "default";
                assigned-clock-rates = <100000000>;
                status = "okay";
                pinctrl-0 = <&pwm_pins>;
              };
            };

          };
        '';
      }];
    };
  };
}

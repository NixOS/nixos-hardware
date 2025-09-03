{ config, lib, ... }:
let
  cfg = config.hardware.orange-pi."5-max".leds;
in
{
  options.hardware.orange-pi."5-max".leds = {
    enable = lib.mkEnableOption "heartbeat leds" // {
      default = true;
    };
  };

  config = lib.mkIf (!cfg.enable) {
    hardware = {
      deviceTree = {
        overlays = [
          {
            name = "orangepi-5-max-enable-leds";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "xunlong,orangepi-5-max";
              };
              / {
                fragment@0 {
                  target = <&led_blue_pwm>;
                  __overlay__ {
                    linux,default-trigger = "none";
                  };
                };
              };
              / {
                fragment@1 {
                  target = <&led_green_pwm>;
                  __overlay__ {
                    linux,default-trigger = "none";
                  };
                };
              };
            '';
          }
        ];
      };
    };
  };
}

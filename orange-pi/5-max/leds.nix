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
            name = "orangepi-5-plus-disable-leds";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "rockchip,rk3588-orangepi-5-max";
              };
              / {
                fragment@0 {
                  target = <&leds>;
                  __overlay__ {
                    status = "okay";
                    blue_led@1 {
                      linux,default-trigger = "none";
                    };
                    green_led@2 {
                      linux,default-trigger = "none";
                    };
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

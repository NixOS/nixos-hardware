{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".gpio-fan;
in
{
  options.hardware = {
    raspberry-pi."4".gpio-fan = {
      enable = lib.mkEnableOption "support for Raspberry Pi style gpio-fan control";

      pin = lib.mkOption {
        type = lib.types.int;
        default = 18;
        description = "BCM GPIO pin used to switch the fan.";
      };

      temperature = lib.mkOption {
        type = lib.types.int;
        default = 55000;
        description = "CPU temperature in millicelsius at which the fan turns on.";
      };

      hysteresis = lib.mkOption {
        type = lib.types.int;
        default = 10000;
        description = "Temperature hysteresis in millicelsius before the fan turns off.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";

    hardware.deviceTree = {
      overlays = [
        {
          name = "rpi4-gpio-fan";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";

              fragment@0 {
                target-path = "/";
                __overlay__ {
                  fan0: gpio-fan@0 {
                    compatible = "gpio-fan";
                    gpios = <&gpio ${toString cfg.pin} 0>;
                    gpio-fan,speed-map = <0 0>,
                                         <5000 1>;
                    #cooling-cells = <2>;
                  };
                };
              };

              fragment@1 {
                target = <&cpu_thermal>;
                __overlay__ {
                  polling-delay = <2000>; /* milliseconds */
                };
              };

              fragment@2 {
                target = <&thermal_trips>;
                __overlay__ {
                  cpu_hot: trip-point@0 {
                    temperature = <${toString cfg.temperature}>;
                    hysteresis = <${toString cfg.hysteresis}>;
                    type = "active";
                  };
                };
              };

              fragment@3 {
                target = <&cooling_maps>;
                __overlay__ {
                  map0 {
                    trip = <&cpu_hot>;
                    cooling-device = <&fan0 1 1>;
                  };
                };
              };
            };
          '';
        }
      ];
    };
  };
}

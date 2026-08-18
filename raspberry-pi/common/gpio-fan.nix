# Upstream overlay source:
# https://github.com/raspberrypi/linux/blob/rpi-6.18.y/arch/arm/boot/dts/overlays/gpio-fan-overlay.dts

{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi.gpio-fan;
in
{
  options.hardware.raspberry-pi.gpio-fan = {
    enable = lib.mkEnableOption "support for Raspberry Pi-style GPIO fan control";

    pin = lib.mkOption {
      type = lib.types.int;
      default = 12;
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

  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi.configtxt.deviceTreeOverlays.all = [
      {
        gpio-fan = {
          gpiopin = cfg.pin;
          temp = cfg.temperature;
          hyst = cfg.hysteresis;
        };
      }
    ];
  };
}

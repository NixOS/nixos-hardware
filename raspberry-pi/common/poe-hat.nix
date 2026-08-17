{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi.poe-hat;
  overlay = {
    rpi-poe = {
      poe_fan_temp0 = cfg.fan.temperature0;
      poe_fan_temp0_hyst = cfg.fan.hysteresis0;
      poe_fan_temp1 = cfg.fan.temperature1;
      poe_fan_temp1_hyst = cfg.fan.hysteresis1;
      poe_fan_temp2 = cfg.fan.temperature2;
      poe_fan_temp2_hyst = cfg.fan.hysteresis2;
      poe_fan_temp3 = cfg.fan.temperature3;
      poe_fan_temp3_hyst = cfg.fan.hysteresis3;
    };
  };
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [
        "hardware"
        "raspberry-pi"
        "4"
        "poe-hat"
      ]
      [
        "hardware"
        "raspberry-pi"
        "poe-hat"
      ]
    )
  ];

  options.hardware.raspberry-pi.poe-hat = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "support for the Raspberry Pi PoE HAT";
        fan = lib.mkOption {
          type = lib.types.submodule {
            options = {
              temperature0 = lib.mkOption {
                type = lib.types.int;
                default = 40000;
                description = "Temperature threshold 0.";
              };
              hysteresis0 = lib.mkOption {
                type = lib.types.int;
                default = 2000;
                description = "Temperature hysteresis 0.";
              };
              temperature1 = lib.mkOption {
                type = lib.types.int;
                default = 45000;
                description = "Temperature threshold 1.";
              };
              hysteresis1 = lib.mkOption {
                type = lib.types.int;
                default = 2000;
                description = "Temperature hysteresis 1.";
              };
              temperature2 = lib.mkOption {
                type = lib.types.int;
                default = 50000;
                description = "Temperature threshold 2.";
              };
              hysteresis2 = lib.mkOption {
                type = lib.types.int;
                default = 2000;
                description = "Temperature hysteresis 2.";
              };
              temperature3 = lib.mkOption {
                type = lib.types.int;
                default = 55000;
                description = "Temperature threshold 3.";
              };
              hysteresis3 = lib.mkOption {
                type = lib.types.int;
                default = 5000;
                description = "Temperature hysteresis 3.";
              };
            };
          };

          default = { };
          description = "Fan configuration.";
        };
      };
    };
    default = { };
    description = "Support for the Raspberry Pi PoE HAT on Raspberry Pi 3B+ and 4B.";
  };

  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi.configtxt.deviceTreeOverlays = {
      "board-type=0x0d" = [ overlay ];
      "board-type=0x11" = [ overlay ];
    };
  };
}

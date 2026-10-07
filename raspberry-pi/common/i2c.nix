{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi;
in
{
  imports = [ ./config-txt.nix ];

  options.hardware.raspberry-pi = {
    i2c0 = {
      enable = lib.mkEnableOption "the firmware I2C0 bus and i2c group access";
      frequency = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          I2C0 clock frequency in Hz.
          A null value keeps the firmware default.
        '';
      };
    };
    i2c1 = {
      enable = lib.mkEnableOption "the firmware I2C1 bus and i2c group access";
      frequency = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          I2C1 clock frequency in Hz.
          A null value keeps the firmware default.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.i2c0.enable {
      boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
      hardware.i2c.enable = lib.mkDefault true;
      hardware.raspberry-pi.configtxt.settings = lib.genAttrs [ "pi2" "pi3" "pi4" "pi5" ] (_: {
        dtparam = [
          "i2c0=on"
        ]
        ++ lib.optional (cfg.i2c0.frequency != null) "i2c0_baudrate=${toString cfg.i2c0.frequency}";
      });
    })
    (lib.mkIf cfg.i2c1.enable {
      boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
      hardware.i2c.enable = lib.mkDefault true;
      hardware.raspberry-pi.configtxt.settings = lib.genAttrs [ "pi2" "pi3" "pi4" "pi5" ] (_: {
        dtparam = [
          "i2c1=on"
        ]
        ++ lib.optional (cfg.i2c1.frequency != null) "i2c1_baudrate=${toString cfg.i2c1.frequency}";
      });
    })
  ];
}

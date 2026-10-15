{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi;
  buses = [
    "i2c0"
    "i2c1"
  ];
in
{
  imports = [ ./config-txt.nix ];

  options.hardware.raspberry-pi = lib.genAttrs buses (bus: {
    enable = lib.mkEnableOption "the firmware ${lib.toUpper bus} bus and i2c group access";
    frequency = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        ${lib.toUpper bus} clock frequency in Hz.
        A null value keeps the firmware default.
      '';
    };
  });

  config = lib.mkMerge (
    map (
      bus:
      lib.mkIf cfg.${bus}.enable {
        # Omit FDT/FDTDIR so U-Boot keeps the firmware's I2C parameters.
        boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
        hardware.i2c.enable = lib.mkDefault true;
        hardware.raspberry-pi.configtxt.settings = lib.genAttrs [ "pi2" "pi3" "pi4" "pi5" ] (_: {
          dtparam = [
            "${bus}=on"
          ]
          ++ lib.optional (cfg.${bus}.frequency != null) "${bus}_baudrate=${toString cfg.${bus}.frequency}";
        });
      }
    ) buses
  );
}

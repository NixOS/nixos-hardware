{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.raspberry-pi."4";
  simple-overlay = { target, status }: {
    name = "${target}-${status}-overlay";
    dtsText = ''
      /dts-v1/;
      /plugin/;
      / {
        compatible = "brcm,bcm2711";
        fragment@0 {
          target = <&${target}>;
          __overlay__ {
            status = "${status}";
          };
        };
      };
    '';
  };
in
{
  options.hardware.raspberry-pi."4" = {
    i2c0.enable = lib.mkEnableOption ''
      Turn on the VideoCore I2C bus (maps to /dev/i2c-22) and enable access from the i2c group.
      After a reboot, i2c-tools (e.g. i2cdetect -F 22) should work for root or any user in i2c.
    '';
    i2c1.enable = lib.mkEnableOption ''
      Turn on the ARM I2C bus (/dev/i2c-1 on GPIO pins 3 and 5) and enable access from the i2c group.
      After a reboot, i2c-tools (e.g. i2cdetect -F 1) should work for root or any user in i2c.
    '';
  };
  config.hardware = lib.mkMerge [
    (lib.mkIf cfg.i2c0.enable {
      i2c.enable = lib.mkDefault true;
      deviceTree = {
        overlays = [ (simple-overlay { target = "i2c0if"; status = "okay"; }) ];
      };
    })
    (lib.mkIf cfg.i2c1.enable {
      i2c.enable = lib.mkDefault true;
      deviceTree = {
        overlays = [ (simple-overlay { target = "i2c1"; status = "okay"; }) ];
      };
    })
  ];
}

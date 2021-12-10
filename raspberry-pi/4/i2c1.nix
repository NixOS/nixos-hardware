{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.raspberry-pi."4".i2c1;
in
{
  options.hardware = {
    raspberry-pi."4".i2c1 = {
      enable = lib.mkEnableOption ''
        Turn on the ARM I2C bus (/dev/i2c-1 on GPIO pins 3 and 5) and enable access from the i2c group.
        After a reboot, i2c-tools (e.g. i2cdetect -F 1) should work for root or any user in i2c.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      i2c.enable = true;
      deviceTree = {
        overlays = [
          # Equivalent to dtparam=i2c1=on
          {
            name = "i2c1-on-overlay";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "brcm,bcm2711";
                fragment@0 {
                  target = <&i2c1>;
                  __overlay__ {
                    #address-cells = <1>;
                    #size-cells = <0>;
                    status = "okay";
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

{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".backlight;
in
{
  options.hardware = {
    raspberry-pi."4".backlight = {
      enable = lib.mkEnableOption "the backlight support for the Raspberry Pi official Touch Display";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.deviceTree = {
      overlays = [
        # This overlay was originally taken from:
        # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/rpi-backlight-overlay.dts
        # The only modification made was to change the compatible field to bcm2711
        # this is the same as for the 5.15.y kernel
        {
          name = "rpi-backlight-overlay";
          dtsText = ''
            /*
             * Devicetree overlay for mailbox-driven Raspberry Pi DSI Display
             * backlight controller
             */
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";

              fragment@0 {
                target-path = "/";
                __overlay__ {
                  rpi_backlight: rpi_backlight {
                    compatible = "raspberrypi,rpi-backlight";
                    firmware = <&firmware>;
                    status = "okay";
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

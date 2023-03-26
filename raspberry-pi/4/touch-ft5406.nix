{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".touch-ft5406;
in
{
  options.hardware = {
    raspberry-pi."4".touch-ft5406 = {
      enable = lib.mkEnableOption ''
        Enable the touch controller of the official Raspberry Pi touch diplay.

        The overlay is taken from the official Raspberry Pi Linux fork, and
        the `compatible` field is updated to match the target device tree.
        https://github.com/raspberrypi/linux/blob/14b35093ca68bf2c81bbc90aace5007142b40b40/arch/arm/boot/dts/overlays/rpi-ft5406-overlay.dts

        For more information about the touch display, please refer to:
        https://www.raspberrypi.com/documentation/accessories/display.html
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Configure for modesetting in the device tree
    hardware.deviceTree = {
      overlays = [
        # this *should* be equivalent to (which doesn't work):
        # https://github.com/raspberrypi/linux/blob/rpi-5.10.y/arch/arm/boot/dts/overlays/dwc2-overlay.dts
        # but actually it's obtained using
        # dtc -I dtb -O dts ${config.hardware.deviceTree.kernelPackage}/dtbs/overlays/dwc2.dtbo
        # (changes: modified top-level "compatible" field)
        # which is slightly different and works
        {
          name = "rpi-ft5406-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
            	compatible = "brcm,bcm2711";

            	fragment@0 {
            		target-path = "/soc/firmware";
            		__overlay__ {
            			ts: touchscreen {
            				compatible = "raspberrypi,firmware-ts";
            				touchscreen-size-x = <800>;
            				touchscreen-size-y = <480>;
            			};
            		};
            	};

            	__overrides__ {
            		touchscreen-size-x = <&ts>,"touchscreen-size-x:0";
            		touchscreen-size-y = <&ts>,"touchscreen-size-y:0";
            		touchscreen-inverted-x = <&ts>,"touchscreen-inverted-x?";
            		touchscreen-inverted-y = <&ts>,"touchscreen-inverted-y?";
            		touchscreen-swapped-x-y = <&ts>,"touchscreen-swapped-x-y?";
                    };
            };
          '';
        }
      ];
    };
  };
}

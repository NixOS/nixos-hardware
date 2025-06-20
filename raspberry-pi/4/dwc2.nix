{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".dwc2;
in
{
  options.hardware = {
    raspberry-pi."4".dwc2 = {
      enable = lib.mkEnableOption ''
        Enable the UDC controller to support USB OTG gadget functions.

        In order to verify that this works, connect the Raspberry Pi with
        another computer via the USB C cable, and then do one of:

        - `modprobe g_serial`
        - `modprobe g_mass_storage file=/path/to/some/iso-file.iso`

        On the Raspberry Pi, `dmesg` should then show success-indicating output
        that is related to the dwc2 and g_serial/g_mass_storage modules.
        On the other computer, a serial/mass-storage device should pop up in
        the system logs.

        For more information about what gadget functions exist along with handy
        guides on how to test them, please refer to:
        https://www.kernel.org/doc/Documentation/usb/gadget-testing.txt
      '';
      dr_mode = lib.mkOption {
        type = lib.types.enum [
          "host"
          "peripheral"
          "otg"
        ];
        default = "otg";
        description = ''
          Dual role mode setting for the dwc2 USB controller driver.
        '';
      };
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
          name = "dwc2-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
              compatible = "brcm,bcm2711";

              fragment@0 {
                target = <&usb>;
                #address-cells = <0x01>;
                #size-cells = <0x01>;

                __overlay__ {
                  compatible = "brcm,bcm2835-usb";
                  dr_mode = "${cfg.dr_mode}";
                  g-np-tx-fifo-size = <0x20>;
                  g-rx-fifo-size = <0x22e>;
                  g-tx-fifo-size = <0x200 0x200 0x200 0x200 0x200 0x100 0x100>;
                  status = "okay";
                  phandle = <0x01>;
                };
              };
            };
          '';
        }
      ];
    };
  };
}

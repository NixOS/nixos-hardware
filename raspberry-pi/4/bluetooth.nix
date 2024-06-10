{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".bluetooth;
in
{
  options.hardware = {
    raspberry-pi."4".bluetooth = {
      enable = lib.mkEnableOption ''
        configuration for bluetooth
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = lib.mkDefault true;
    # doesn't work for the CM module, so we exclude e.g. bcm2711-rpi-cm4.dts
    hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";

    hardware.deviceTree = {
      overlays = [
        {
          name = "bluetooth-overlay";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
                compatible = "brcm,bcm2711";

                fragment@0 {
                    target = <&uart0_pins>;
                    __overlay__ {
                            brcm,pins = <30 31 32 33>;
                            brcm,pull = <2 0 0 2>;
                    };
                };
            };
          '';
        }
      ];
    };
  };
}

{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".tv-hat;
in {
  options.hardware = {
    raspberry-pi."4".tv-hat = {
      enable = lib.mkEnableOption ''
        support for the Raspberry Pi TV Hat.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = lib.mkDefault true;
    hardware.deviceTree.filter = "*-rpi-4-*.dtb";
    hardware.deviceTree.overlays = [
      # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/spi0-0cs-overlay.dts
      # https://github.com/raspberrypi/linux/blob/rpi-6.1.y/arch/arm/boot/dts/overlays/rpi-tv-overlay.dts
      {
        name = "spi0-0cs.dtbo";
        dtsText = "
        /dts-v1/;
        /plugin/;
    
        /{
          compatible = \"brcm,bcm2711\";
          fragment@0 {
            target-path = \"/soc/gpio@7e200000\";
            __overlay__ {
              spi0_pins: spi0_pins {
                brcm,pins = <0x09 0x0a 0x0b>;
                brcm,function = <0x04>;
                phandle = <0x0d>;
              };

              spi0_cs_pins: spi0_cs_pins {
                brcm,pins = <0x08 0x07>;
                brcm,function = <0x01>;
                phandle = <0x0e>;
              };
            };
          };
          fragment@1 {
            target-path = \"/soc/spi@7e204000\";
            __overlay__ {
              pinctrl-names = \"default\";
              pinctrl-0 = <&spi0_pins &spi0_cs_pins>;
              cs-gpios = <&gpio 8 1>, <&gpio 7 1>;
              status = \"okay\";

              spidev0: spidev@0{
                compatible = \"lwn,bk4\";
                reg = <0>;      /* CE0 */
                #address-cells = <1>;
                #size-cells = <0>;
                spi-max-frequency = <125000000>;
              };

              spidev1: spidev@1{
                compatible = \"lwn,bk4\";
                reg = <1>;      /* CE1 */
                #address-cells = <1>;
                #size-cells = <0>;
                spi-max-frequency = <125000000>;
              };
            };
          };
      };";
      }
      {
        name = "rpi-tv-overlay";
        dtsText = ''
          // rpi-tv HAT

          /dts-v1/;
          /plugin/;

          / {
            compatible = "brcm,bcm2711";

            fragment@0 {
              target = <&spidev0>;
              __overlay__ {
                status = "disabled";
              };
            };

            fragment@1 {
              target = <&spi0>;
              __overlay__ {
                /* needed to avoid dtc warning */
                #address-cells = <1>;
                #size-cells = <0>;

                status = "okay";

                cxd2880@0 {
                  compatible = "sony,cxd2880";
                  reg = <0>; /* CE0 */
                  spi-max-frequency = <50000000>;
                  status = "okay";
                };
              };
            };
          };
        '';
      }
    ];
  };
}

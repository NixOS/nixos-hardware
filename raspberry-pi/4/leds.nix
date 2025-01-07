{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".leds;
  mkDisableOption = name: lib.mkOption {
    default = false;
    example = true;
    description = "Whether to disable ${name}.";
    type = lib.types.bool;
  };
in
{
  options.hardware = {
    raspberry-pi."4".leds = {
      eth.disable = mkDisableOption ''ethernet LEDs.'';
      act.disable = mkDisableOption ''activity LED.'';
      pwr.disable = mkDisableOption ''power LED.'';
    };
  };

  # Adapted from: https://gist.github.com/SFrijters/206d2c09656affb04284f076c75a1969
  config = lib.mkMerge [
    (lib.mkIf (cfg.eth.disable || cfg.act.disable || cfg.pwr.disable) {
      hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = lib.mkDefault true;
      hardware.deviceTree.filter = "*-rpi-4-*.dtb";
    })
    (lib.mkIf cfg.eth.disable {
      hardware.deviceTree = {
        overlays = [
          # https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README
          # eth_led0                Set mode of LED0 - amber on Pi3B+ (default "1"),
          #                         green on Pi4 (default "0").
          #                         The legal values are:
          #
          #                         Pi4
          #
          #                         0=Speed/Activity         1=Speed
          #                         2=Flash activity         3=FDX
          #                         4=Off                    5=On
          #                         6=Alt                    7=Speed/Flash
          #                         8=Link                   9=Activity
          #
          # Debugging:
          # $ hexdump /proc/device-tree/scb/ethernet@7d580000/mdio@e14/ethernet-phy@1/led-modes
          {
            name = "disable-eth-leds";
            filter = "*rpi-4-b*";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              /{
                  compatible = "raspberrypi,4-model-b";
                  fragment@0 {
                      target = <&phy1>;
                      __overlay__ {
                          led-modes = <0x04 0x04>;
                      };
                  };
              };
            '';
          }
        ];
      };
    })
    (lib.mkIf cfg.act.disable {
      hardware.deviceTree = {
        overlays = [
          # Debugging:
          # $ hexdump /proc/device-tree/leds/led-act/gpios
          # $ cat /proc/device-tree/leds/led-act/linux,default-trigger
          {
            name = "disable-act-led";
            filter = "*rpi-4-b*";
            dtsText = let
              kernelVersion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.2";
              target = if kernelVersion then "<&led_act>" else "<&act_led>";
            in ''
              /dts-v1/;
              /plugin/;
              /{
                  compatible = "raspberrypi,4-model-b";
                  fragment@0 {
                      target = ${target};
                      __overlay__ {
                          gpios = <&gpio 42 0>; /* first two values copied from bcm2711-rpi-4-b.dts */
                          linux,default-trigger = "none";
                      };
                  };
              };
            '';
          }
        ];
      };
    })
    (lib.mkIf cfg.pwr.disable {
      hardware.deviceTree = {
        overlays = [
          # Debugging:
          # $ hexdump /proc/device-tree/leds/led-pwr/gpios
          # $ cat /proc/device-tree/leds/led-pwr/linux,default-trigger
          {
            name = "disable-pwr-led";
            filter = "*rpi-4-b*";
            dtsText = let
              kernelVersion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.2";
              target = if kernelVersion then "<&led_pwr>" else "<&pwr_led>";
            in ''
              /dts-v1/;
              /plugin/;
              /{
                  compatible = "raspberrypi,4-model-b";
                  fragment@0 {
                      target = ${target};
                      __overlay__ {
                          gpios = <&expgpio 2 0>; /* first two values copied from bcm2711-rpi-4-b.dts */
                          linux,default-trigger = "default-on";
                      };
                  };
              };
            '';
          }
        ];
      };
    })
  ];
}

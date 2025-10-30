{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi."4".tc358743;
in
{
  options.hardware = {
    raspberry-pi."4".tc358743 = {
      enable = lib.mkEnableOption "" // {
        description = ''
          Enable support for the Toshiba TC358743 HDMI-to-CSI-2 converter.

          This can be tested with a plugged in converter device and for example
          running ustreamer (which starts webservice providing a camera stream):
          ''${pkgs.ustreamer}/bin/ustreamer --persistent --dv-timings
        '';
      };
      lanes = lib.mkOption {
        type = lib.types.enum [
          2
          4
        ];
        default = 2;
        description = ''
          Number of CSI lanes available
        '';
      };
      media-controller = lib.mkEnableOption "" // {
        description = ''
          Enable support for the Media Controller API.

          See https://forums.raspberrypi.com/viewtopic.php?t=322076 for details
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
    hardware.deviceTree.overlays = [
      {
        name = "tc358743-overlay";
        dtsText = ''
          /dts-v1/;

          / {
            compatible = "brcm,bcm2711";

            fragment@0 {
              target = <0xffffffff>;

              __overlay__ {
                #address-cells = <0x01>;
                #size-cells = <0x00>;
                status = "okay";

                tc358743@0f {
                  compatible = "toshiba,tc358743";
                  reg = <0x0f>;
                  status = "okay";
                  clocks = <0x01>;
                  clock-names = "refclk";

                  port {

                    endpoint {
                      remote-endpoint = <0x02>;
                      clock-lanes = <0x00>;
                      clock-noncontinuous;
                      link-frequencies = <0x00 0x1cf7c580>;
                      phandle = <0x03>;
                    };
                  };
                };
              };
            };

            fragment@1 {
              target = <0xffffffff>;

              __overlay__ {
                status = "okay";

                ${
                  if cfg.media-controller then
                    ""
                  else
                    ''
                      compatible = "brcm,bcm2835-unicam-legacy";
                    ''
                }

                port {

                  endpoint {
                    remote-endpoint = <0x03>;
                    phandle = <0x02>;
                  };
                };
              };
            };

            fragment@2 {
              target = <0x03>;

              ${
                if cfg.lanes == 2 then
                  ''
                    __overlay__ {
                      data-lanes = <0x01 0x02>;
                    };
                  ''
                else
                  ""
              }
            };

            fragment@3 {
              target = <0x03>;

              ${
                if cfg.lanes == 4 then
                  ''
                    __overlay__ {
                      data-lanes = <0x01 0x02 0x03 0x04>;
                    };
                  ''
                else
                  ""
              }
            };

            fragment@4 {
              target = <0xffffffff>;

              __overlay__ {
                status = "okay";
              };
            };

            fragment@5 {
              target = <0xffffffff>;

              __overlay__ {
                status = "okay";
              };
            };

            fragment@6 {
              target-path = [2f 00];

              __overlay__ {

                bridge-clk {
                  compatible = "fixed-clock";
                  #clock-cells = <0x00>;
                  clock-frequency = <0x19bfcc0>;
                  phandle = <0x01>;
                };
              };
            };

            fragment@7 {
              target = <0x02>;

              ${
                if cfg.lanes == 2 then
                  ''
                    __overlay__ {
                      data-lanes = <0x01 0x02>;
                    };
                  ''
                else
                  ""
              }
            };

            fragment@8 {
              target = <0x02>;

              ${
                if cfg.lanes == 4 then
                  ''
                    __overlay__ {
                      data-lanes = <0x01 0x02 0x03 0x04>;
                    };
                  ''
                else
                  ""
              }
            };

            __overrides__ {
              link-frequency = [00 00 00 03 6c 69 6e 6b 2d 66 72 65 71 75 65 6e 63 69 65 73 23 30 00];
            };

            __symbols__ {
              tc358743 = "/fragment@0/__overlay__/tc358743@0f/port/endpoint";
              csi1_ep = "/fragment@1/__overlay__/port/endpoint";
              tc358743_clk = "/fragment@6/__overlay__/bridge-clk";
            };

            __fixups__ {
              i2c_csi_dsi = "/fragment@0:target:0";
              csi1 = "/fragment@1:target:0";
              i2c0if = "/fragment@4:target:0";
              i2c0mux = "/fragment@5:target:0";
            };

            __local_fixups__ {

              fragment@0 {

                __overlay__ {

                  tc358743@0f {
                    clocks = <0x00>;

                    port {

                      endpoint {
                        remote-endpoint = <0x00>;
                      };
                    };
                  };
                };
              };

              fragment@1 {

                __overlay__ {

                  port {

                    endpoint {
                      remote-endpoint = <0x00>;
                    };
                  };
                };
              };

              fragment@2 {
                target = <0x00>;
              };

              fragment@3 {
                target = <0x00>;
              };

              fragment@7 {
                target = <0x00>;
              };

              fragment@8 {
                target = <0x00>;
              };

              __overrides__ {
                link-frequency = <0x00>;
              };
            };
          };
        '';
      }
    ];
  };
}

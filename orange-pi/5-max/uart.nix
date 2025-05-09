{ config, lib, ... }:
let
  cfg = config.hardware.orange-pi."5-max".uartDebug;
in
{
  options.hardware.orange-pi."5-max".uartDebug = {
    enable = lib.mkEnableOption "UART2 serial console" // {
      default = true;
    };
    baudRate = lib.mkOption {
      type = lib.types.int;
      default = 1500000;
      description = "Baud rate for the UART2 serial console";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "earlycon=uart8250,mmio32,0xfeb50000"
      "console=ttyS2,${toString cfg.baudRate}"
    ];
    hardware = {
      deviceTree = {
        overlays = [
          {
            name = "rockchip-rk3588-uart2-m0";
            dtsText = ''
              /dts-v1/;
              /plugin/;
              / {
                compatible = "rockchip,rk3588";
              };
              / {
                metadata {
                  title = "Enable UART2-M0";
                  compatible = "radxa,rock-5a", "radxa,rock-5b";
                  category = "misc";
                  exclusive = "GPIO0_B5", "GPIO0_B6";
                  description = "Enable UART2-M0.\nOn Radxa ROCK 5A this is TX pin 8 and RX pin 10.\nOn Radxa ROCK 5B this is TX pin 8 and this is RX pin 10.";
                };
                fragment@0 {
                  target = <&uart2>;
                  __overlay__ {
                    status = "okay";
                    pinctrl-0 = <&uart2m0_xfer>;
                  };
                };
                fragment@1 {
                  target = <&fiq_debugger>;
                  __overlay__ {
                    status = "disabled";
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

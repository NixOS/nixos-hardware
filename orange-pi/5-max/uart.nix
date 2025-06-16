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
  };
}

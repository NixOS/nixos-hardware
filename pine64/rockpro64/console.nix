{ config, lib, ... }:
{
  options.hardware.rockpro64.console = lib.mkOption {
    default = "hdmi";
    description = "Default console to use at boot.";
    type = lib.types.enum [
      "hdmi"
      "serial"
    ];
  };
  config = lib.mkIf (config.hardware.rockpro64.console == "hdmi") {
    boot.kernelParams = [
      "console=ttyS0"
      "console=tty0"
    ];
  };
}

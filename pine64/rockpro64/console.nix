{ config, lib, ... }:
let
  cfg = config.hardware."rockpro64".console;
  hdmi = "hdmi";
  serial = "serial";
in
{
  options.hardware."rockpro64".console = lib.mkOption {
    default = "hdmi";
    description = "Default console to use at boot.";
    type = lib.types.enum [
      hdmi
      serial
    ];
  };
  config =
    lib.mkIf (cfg == hdmi) {
      boot.kernelParams = [
        "console=ttyS0"
        "console=tty0"
      ];
    };
}

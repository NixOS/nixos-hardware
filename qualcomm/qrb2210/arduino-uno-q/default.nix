{ lib, ... }:
{
  imports = [
    ../modules.nix
  ];

  hardware.deviceTree = {
    filter = lib.mkDefault "qrb2210-*.dtb";
    name = lib.mkDefault "qcom/qrb2210-arduino-imola.dtb";
  };
}

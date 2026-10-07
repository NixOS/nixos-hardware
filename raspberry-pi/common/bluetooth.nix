{ config, lib, ... }:

let
  cfg = config.hardware.raspberry-pi.bluetooth;
in
{
  imports = [ ./config-txt.nix ];

  options.hardware.raspberry-pi.bluetooth.enable =
    lib.mkEnableOption "onboard Bluetooth through kernel discovery";

  config = lib.mkIf cfg.enable {
    boot.loader.generic-extlinux-compatible.useGenerationDeviceTree = false;
    hardware.bluetooth.enable = lib.mkDefault true;

    hardware.raspberry-pi.configtxt.settings = lib.genAttrs [ "pi3" "pi4" "pi5" ] (_: {
      dtparam = [ "krnbt=on" ];
    });
  };
}

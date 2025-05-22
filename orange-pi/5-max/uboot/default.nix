{ config, pkgs, lib, ... }:
let
  cfg = config.hardware.orange-pi."5-max".uboot;
  uboot = pkgs.callPackage ./package.nix {
    enableUart = config.hardware.orange-pi."5-max".uartDebug.enable;
    baudRate = config.hardware.orange-pi."5-max".uartDebug.baudRate;
  };
  updater-flash = pkgs.writeShellApplication {
    name = "orangepi5max-firmware-update-flash";
    runtimeInputs = [ pkgs.mtdutils ];
    text = ''
      flashcp -v ${cfg.package}/u-boot-rockchip-spi.bin /dev/mtd0
    '';
  };
  updater-sd = pkgs.writeShellApplication {
    name = "orangepi5max-firmware-update-sd";
    runtimeInputs = [ ];
    text = ''
      dd if=${cfg.package}/u-boot-rockchip.bin of=/dev/mmcblk1 seek=64 conv=notrunc
    '';
  };
in
{
  options.hardware = {
    orange-pi."5-max".uboot = {
      package = lib.mkOption {
        type = lib.types.package;
        default = uboot;
        description = "uboot package to use in sd image and updater scripts";
      };
      updater.enable = lib.mkEnableOption "updater program installation";
    };
  };

  config = lib.mkIf cfg.updater.enable {
    environment.systemPackages = [
      updater-flash
      updater-sd
    ];
  };
}

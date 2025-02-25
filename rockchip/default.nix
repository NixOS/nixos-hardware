{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.rockchip;
in {
  imports = [
    ./rk3328
    ./rk3399
    ./rk3588
  ];

  options.hardware.rockchip = {
    enable = lib.mkEnableOption "Rockchip SoC support";
    diskoImageName = lib.mkOption {
      type = lib.types.str;
      default = "main.raw";
      description = ''
        The output image name of Disko.
        You need to match this value with the real image name. Setting it alone
        won't change the output image name, as it is controlled by Disko module.

        Can be used in diskoExtraPostVM.
      '';
    };
    platformFirmware = lib.mkPackageOption pkgs "platform firmware" {
      default = null;
    };
    diskoExtraPostVM = lib.mkOption {
      type = lib.types.str;
      default = ''
        ${lib.getExe' pkgs.coreutils "dd"} conv=notrunc,fsync if=${config.hardware.rockchip.platformFirmware}/idbloader.img of=$out/${config.hardware.rockchip.diskoImageName} bs=512 seek=64
        ${lib.getExe' pkgs.coreutils "dd"} conv=notrunc,fsync if=${config.hardware.rockchip.platformFirmware}/u-boot.itb of=$out/${config.hardware.rockchip.diskoImageName} bs=512 seek=16384
      '';
      defaultText = lib.literalExpression ''
        ${lib.getExe' pkgs.coreutils "dd"} conv=notrunc,fsync if=${config.hardware.rockchip.platformFirmware}/idbloader.img of=$out/${config.hardware.rockchip.diskoImageName} bs=512 seek=64
        ${lib.getExe' pkgs.coreutils "dd"} conv=notrunc,fsync if=${config.hardware.rockchip.platformFirmware}/u-boot.itb of=$out/${config.hardware.rockchip.diskoImageName} bs=512 seek=16384
      '';
      description = ''
        The post VM hook for Disko's Image Builder.
        Can be used to install platform firmware like U-Boot.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [ "console=ttyS2,1500000n8" ];
    };
  };
}

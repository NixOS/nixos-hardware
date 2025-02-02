{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.radxa.rock-4c-plus;
  rkCfg = config.hardware.rockchip;
in {
  imports = [
    ../.
    ../../rockchip/rk3399
  ];

  options.hardware.radxa.rock-4c-plus = {
    platformFirmware = lib.mkPackageOption pkgs "ubootRock4CPlus" { };
  };

  config = {
    hardware = {
      radxa.enable = true;
      rockchip = {
        rk3399.enable = true;
        diskoExtraPostVM = ''
          dd conv=notrunc,fsync if=${cfg.platformFirmware}/idbloader.img of=$out/${rkCfg.diskoImageName} bs=512 seek=64
          dd conv=notrunc,fsync if=${cfg.platformFirmware}/u-boot.itb of=$out/${rkCfg.diskoImageName} bs=512 seek=16384
        '';
      };
    };
  };
}

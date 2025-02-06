{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.radxa.rock-5b;
  rkCfg = config.hardware.rockchip;
in {
  imports = [
    ../.
    ../../rockchip
  ];

  options.hardware.radxa.rock-5b = {
    platformFirmware = lib.mkPackageOption pkgs "ubootRock5ModelB" { };
  };

  config = {
    hardware = {
      radxa.enable = true;
      rockchip = {
        rk3588.enable = true;
        diskoExtraPostVM = ''
          dd conv=notrunc,fsync if=${cfg.platformFirmware}/idbloader.img of=$out/${rkCfg.diskoImageName} bs=512 seek=64
          dd conv=notrunc,fsync if=${cfg.platformFirmware}/u-boot.itb of=$out/${rkCfg.diskoImageName} bs=512 seek=16384
        '';
      };
    };
  };
}

{ lib
, pkgs
, config
, ...
}:
let
  cfg = config.hardware.radxa.rock-pi-4;
  rkCfg = config.hardware.rockchip;
in {
  imports = [
    ../.
    ../../rockchip
  ];

  options.hardware.radxa.rock-pi-4 = {
    platformFirmware = lib.mkPackageOption pkgs "ubootRockPi4" { };
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

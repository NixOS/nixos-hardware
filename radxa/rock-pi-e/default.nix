{ lib
, pkgs
, config
, ...
}: {
  imports = [
    ../.
    ../../rockchip
  ];

  config = {
    hardware = {
      radxa.enable = true;
      rockchip = {
        rk3328.enable = true;
        platformFirmware = pkgs.ubootRockPiE;
      };
    };
  };
}

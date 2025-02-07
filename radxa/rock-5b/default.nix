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
        rk3588.enable = true;
        platformFirmware = pkgs.ubootRock5ModelB;
      };
    };
  };
}

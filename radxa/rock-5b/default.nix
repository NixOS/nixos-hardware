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
        platformFirmware = lib.mkDefault pkgs.ubootRock5ModelB;
      };
    };
  };
}

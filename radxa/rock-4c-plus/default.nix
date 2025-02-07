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
        rk3399.enable = true;
        platformFirmware = lib.mkDefault pkgs.ubootRock4CPlus;
      };
    };
  };
}

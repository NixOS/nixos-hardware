{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ../.
    ../../rockchip
  ];

  config = {
    hardware = {
      radxa.enable = true;
      rockchip = {
        rk3566.enable = true;
        platformFirmware = lib.mkDefault pkgs.ubootRock3C;
      };
    };
  };
}

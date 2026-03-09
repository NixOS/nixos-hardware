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
        platformFirmware = lib.mkDefault pkgs.ubootRadxaZero3W;
      };
      deviceTree = {
        enable = true;
        filter = "*rk3566-radxa-zero-3*.dtb";
      };
    };
  };
}

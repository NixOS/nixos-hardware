{ nixos, lib, pkgs, config, stdenv, ... }:
{
  imports = [
    ../l13
  ];

  # automatic screen orientation
  hardware.sensor.iio.enable = true;

  services.xserver.wacom.enable = lib.mkDefault config.services.xserver.enable;
}

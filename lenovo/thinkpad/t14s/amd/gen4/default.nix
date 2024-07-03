{ lib, pkgs, ... }:
{
  imports = [
    ../.
  ];

  # Fix laptop not properly powering off during shutdown.
  boot.kernelParams = [ "apm=power_off" ];
}

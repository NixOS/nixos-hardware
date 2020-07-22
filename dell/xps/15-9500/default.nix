{ lib, pkgs, ... }:

{
  imports = [
    ./xps-common.nix
  ];

  # This configuration makes intel default
  services.xserver.videoDrivers = lib.mkDefault [ "intel" ];
}

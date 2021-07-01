{ nixos, lib, pkgs, config, stdenv, ... }:
{
  imports = [
    ../.
    ../../yoga.nix
  ];

  services.xserver.wacom.enable = lib.mkDefault config.services.xserver.enable;
}

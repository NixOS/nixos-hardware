{ config, lib, ... }:
{
  imports = [
    ../.
    ../../yoga.nix
  ];

  services = {
    fprintd.enable = lib.mkDefault true;
    fwupd.enable = lib.mkDefault true;
    xserver.wacom.enable = lib.mkDefault config.services.xserver.enable;
  };
}

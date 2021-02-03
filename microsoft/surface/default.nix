{ config, lib, pkgs, ... }: {
  imports = [ ./kernel ./firmware ./hardware_configuration.nix ];

  environment.systemPackages = with pkgs; [ surface-control ];
  users.groups.surface-control = {};
  services.udev.packages = [ pkgs.surface-control ];
}

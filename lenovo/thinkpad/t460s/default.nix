{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
}

{ config, lib, pkgs, ... }:
{
  imports = [
    ./kernel
    ./firmware
    ./hardware_configuration.nix
  ];
}

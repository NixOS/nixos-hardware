{ config, lib, pkgs, ... }:
{
  imports = [
    ./kernel
    ./hardware_configuration.nix
    ./firmware/surface-go/ath10k
  ];
}

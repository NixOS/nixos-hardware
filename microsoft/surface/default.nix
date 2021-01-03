{ config, lib, pkgs, ... }:
{
  imports = [
    ./kernel
    ./firmware
    ./hardware_configuration.nix
  ];

  boot.kernelPackages = surface_kernelPackages.linux_5_10_4;
  # boot.kernelPatches = surface_kernelPatches.linux_5_10;
}

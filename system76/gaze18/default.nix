{ config, lib, pkgs, ... }:
{
  imports = [
    ../.
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/ampere
  ];

  boot.initrd.kernelModules = [ "nvidia" ];

  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
  };

  hardware.nvidia = {

    # modesetting.enable = lib.mkDefault true;

    powerManagement.finegrained = lib.mkDefault true;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}

{ config, lib, pkgs, ... }:
{
  imports = [
    ../.
    ../../common/gpu/nvidia/prime.nix
  ];

  boot.initrd.kernelModules = [ "nvidia" ];

  hardware.opengl = {
    enable = lib.mkDefault true;
    # adds ~100MB of 32-bit mesa drivers.
    driSupport32Bit = lib.mkDefault true;
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

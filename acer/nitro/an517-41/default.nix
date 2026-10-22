{ lib, ... }:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/gpu/nvidia/prime.nix

    ../../battery.nix
  ];

  hardware.nvidia = {
    prime = {
      amdgpuBusId = "PCI:5@0:0:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
    # Consider moving this to common/gpu/nvidia folder (works for Ampere or later)
    dynamicBoost.enable = lib.mkDefault true;
    powerManagement = {
      enable = lib.mkDefault true;
      finegrained = lib.mkDefault true;
    };
  };
}

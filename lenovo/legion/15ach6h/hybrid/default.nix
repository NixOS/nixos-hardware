{ lib, ... }:

{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/gpu/amd
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/ampere
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  hardware.nvidia = {
    powerManagement.enable = lib.mkDefault true;
    powerManagement.finegrained = lib.mkDefault true;

    prime = {
      amdgpuBusId = lib.mkDefault "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}

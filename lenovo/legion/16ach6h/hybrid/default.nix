{ lib, ... }:

{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/cpu/amd/zenpower.nix
    ../../../../common/gpu/amd
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/ampere
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
    ../edid
  ];

  hardware.nvidia = {
    powerManagement.enable = lib.mkDefault true;
    dynamicBoost.enable = lib.mkDefault true;

    prime = {
      amdgpuBusId = lib.mkDefault "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
}

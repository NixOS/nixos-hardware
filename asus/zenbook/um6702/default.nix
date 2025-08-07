{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix

    # iGPU
    ../../../common/gpu/amd

    # dGPU
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere

    ../../../common/pc/laptop
    ../../../common/pc/ssd

    ../../battery.nix
  ];

  hardware.nvidia = {
    dynamicBoost.enable = mkDefault true;

    powerManagement = {
      enable = mkDefault true;
      finegrained = mkDefault true;
    };

    prime = {
      amdgpuBusId = "PCI:1:0:0";
      nvidiaBusId = "PCI:101:0:0";
    };
  };
}

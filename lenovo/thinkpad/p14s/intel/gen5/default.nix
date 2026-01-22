{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../../common/gpu/nvidia/prime.nix
    ../../../../../common/gpu/nvidia/turing
  ];

  hardware = {
    intelgpu.driver = "i915"; # xe driver may be used on newer kernels
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}

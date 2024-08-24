{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../../common/gpu/nvidia/prime.nix
  ];

  hardware = {
    intelgpu.driver = "xe";

    nvidia.prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:3:0:0";
    };
  };
}

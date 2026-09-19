{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../../common/gpu/nvidia/prime.nix
    ../../../../../common/gpu/nvidia/blackwell
  ];

  hardware = {
    intelgpu.driver = "xe";
    nvidia = {
      prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}

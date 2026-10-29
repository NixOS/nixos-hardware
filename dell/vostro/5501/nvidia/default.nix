{ lib, ... }:

{
  imports = [
    ../.
    ../../../../common/gpu/nvidia/prime.nix
  ];

  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };

  hardware.nvidia.open = lib.mkDefault false;
  hardware.nvidia.powerManagement.enable = lib.mkDefault true;
}

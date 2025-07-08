{ lib, ... }:
{
  imports = [
    ../default.nix
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/ada-lovelace
  ];

  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU.
    intelBusId = lib.mkDefault "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU.
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}

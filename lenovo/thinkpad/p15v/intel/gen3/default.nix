{ lib, ... }:
{
  imports = [
    ../.
    ../../../../../common/cpu/intel/alder-lake
    ../../../../../common/gpu/nvidia/prime.nix
    ../../../../../common/gpu/nvidia/turing
  ];

  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}

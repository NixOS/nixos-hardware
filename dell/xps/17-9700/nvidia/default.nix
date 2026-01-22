{ lib, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/turing
    ../common.nix
  ];

  hardware.nvidia.prime = {
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    intelBusId = lib.mkDefault "PCI:0:2:0";
  };
}

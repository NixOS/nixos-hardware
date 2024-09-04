{ ... }:

{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/turing
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

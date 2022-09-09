{ ... }:

{
  imports = [
    ../../common/cpu/amd
    ../../common/gpu/nvidia.nix
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

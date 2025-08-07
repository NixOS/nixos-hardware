{ ... }:

{
  imports = [
    ../../common/cpu/intel/skylake
    ../../common/gpu/nvidia/maxwell
    ../../common/gpu/nvidia/prime.nix
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

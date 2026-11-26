{ ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../battery.nix
  ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

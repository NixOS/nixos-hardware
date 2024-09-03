{ ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/pc/laptop
    ../xps-common.nix
    ../../../../common/gpu/nvidia/pascal
  ];


  # This runs only nvidia, great for games or heavy use of render applications

  ##### disable intel, run nvidia only and as default
  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU.
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU.
    nvidiaBusId = "PCI:1:0:0";
  };
}

{ lib, pkgs, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/gpu/nvidia.nix
    ../../../../common/pc/laptop
    ../xps-common.nix
  ];


  # This runs only nvidia, great for games or heavy use of render applications

  ##### disable intel, run nvidia only and as default
  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU.
    intelBusId = lib.mkDefault "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU.
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}

{ lib, ... }:
{
  imports = [
    ../.
    ../../../../../common/cpu/intel/meteor-lake
    ../../../../../common/gpu/nvidia/ada-lovelace
    ../../../../../common/gpu/nvidia/prime.nix
  ];

  # NVIDIA PRIME hybrid graphics
  # Use `nvidia-offload <command>` to run on discrete GPU
  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}

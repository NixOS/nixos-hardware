{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Specify bus id of Nvidia and Intel graphics.
  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

}

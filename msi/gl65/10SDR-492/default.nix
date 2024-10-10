{ lib, ... }:

{
  imports = [
    ../../../common/pc/laptop/ssd
    ../../../common/cpu/intel/comet-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
  ];

  hardware.bluetooth.enable = lib.mkDefault true;

  hardware.graphics.enable = lib.mkDefault true;

  hardware.nvidia = {
    prime = {
      # Bus ID of the Intel GPU.
      intelBusId = lib.mkDefault "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    };
  };
}

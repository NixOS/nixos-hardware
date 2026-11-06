{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/comet-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  hardware.bluetooth.enable = lib.mkDefault true;
  hardware.graphics.enable = lib.mkDefault true;

  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:2:0:0";
  };
}

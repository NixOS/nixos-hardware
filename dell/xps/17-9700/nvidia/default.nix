{ lib, pkgs, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../../../../common/gpu/nvidia.nix
    ../common.nix
  ];

  hardware.nvidia.prime = {
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    intelBusId = lib.mkDefault "PCI:0:2:0";
  };
}

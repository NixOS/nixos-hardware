{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../../common/cpu/intel/tiger-lake
    ../../../common/gpu/intel
    ../../../common/gpu/nvidia/ampere
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/pc
  ];

  services.thermald.enable = mkDefault true;

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:2:0:0";
  };
}

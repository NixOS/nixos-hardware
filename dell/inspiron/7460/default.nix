{ lib, ... }:

{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/gpu/intel/kaby-lake
    ../../../common/gpu/nvidia/maxwell
    ../../../common/gpu/nvidia/prime.nix
  ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services = {
    thermald.enable = lib.mkDefault true;
    fwupd.enable = lib.mkDefault true;
  };
}

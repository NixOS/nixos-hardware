{ lib, ... }:

{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/hdd
    ../../../common/cpu/intel/skylake
    ../../../common/gpu/nvidia/maxwell
    ../../../common/gpu/nvidia/prime.nix
  ];

  hardware = {
    nvidia.prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };

    enableRedistributableFirmware = lib.mkDefault true;
  };

  services = {
    thermald.enable = lib.mkDefault true;
  };
}

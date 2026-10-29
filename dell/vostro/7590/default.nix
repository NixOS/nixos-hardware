{ lib, ... }:

{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/cpu/intel/coffee-lake
    ../../../common/gpu/nvidia/turing
    ../../../common/gpu/nvidia/prime.nix
  ];

  hardware = {
    nvidia.powerManagement = {
      enable = lib.mkDefault true;
      finegrained = lib.mkDefault true;
    };
    nvidia.prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    enableRedistributableFirmware = lib.mkDefault true;
  };

  services = {
    thermald.enable = lib.mkDefault true;
  };
}

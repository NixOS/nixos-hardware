{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ./edid
  ];

  hardware.amdgpu.loadInInitrd = lib.mkDefault false;

  hardware.nvidia = {
    powerManagement.enable = lib.mkDefault true;

    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  services.thermald.enable = lib.mkDefault true;
}

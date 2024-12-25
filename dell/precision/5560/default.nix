{ lib, ... }:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/cpu/intel/tiger-lake
    ../../../common/gpu/nvidia/turing
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  services.fwupd.enable = true;

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

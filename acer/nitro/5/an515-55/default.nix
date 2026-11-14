{ lib, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/turing
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    powerManagement.enable = lib.mkDefault true;

    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
}

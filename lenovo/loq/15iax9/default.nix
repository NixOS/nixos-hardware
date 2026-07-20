{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel/alder-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/pc/laptop
    ../../../common/pc/sdd
  ];

  hardware.nvidia = {
    powerManagement = {
      enable = lib.mkDefault true;
      finegrained = lib.mkDefault true;
    };
    modesetting.enable = lib.mkDefault true;
    dynamicBoost.enable = lib.mkDefault true;

    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  services.thermald.enable = lib.mkDefault true;

  # √(1920² + 1080²) px / 15.60 in ≃ 141 dpi
  services.xserver.dpi = 141;
}

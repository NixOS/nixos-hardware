{ lib, config, ... }:
{
  imports = [
    ../.
    ../../../common/cpu/intel/whiskey-lake
    ../../../common/pc/ssd
    ../../../common/gpu/nvidia/pascal
    ../../../common/gpu/nvidia/prime-sync.nix
  ];

  hardware = {
    graphics.enable = lib.mkDefault true;

    nvidia = {
      prime = {
        intelBusId = lib.mkDefault "PCI:0:2:0";
        nvidiaBusId = lib.mkDefault "PCI:60:0:0";
      };

      powerManagement.enable = lib.mkDefault config.hardware.nvidia.prime.sync.enable;
    };
  };
}

{
  lib,
  config,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/hidpi.nix
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.lenovo-legion-module ];

  hardware = {
    nvidia = {
      powerManagement.enable = lib.mkDefault true;

      prime = {
        intelBusId = "PCI:00:02:0";
        nvidiaBusId = "PCI:01:00:0";
      };
    };
  };

  services.thermald.enable = lib.mkDefault true;

  services.xserver.dpi = 189;
}

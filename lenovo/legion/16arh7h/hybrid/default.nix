{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/gpu/amd
    ../../../../common/gpu/nvidia/prime.nix # prime offload
    ../../../../common/gpu/nvidia/ampere # use open drivers
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  hardware = {
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = lib.mkDefault true;
      powerManagement.finegrained = lib.mkDefault true;
      prime = {
        amdgpuBusId = lib.mkDefault "PCI:52:0:0"; # Hexadecimal 34:00.0
        nvidiaBusId = lib.mkDefault "PCI:1:0:0"; # Hexadecimal 01:00.0
      };
    };
  };
}

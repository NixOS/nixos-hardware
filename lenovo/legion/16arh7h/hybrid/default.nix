{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/gpu/nvidia/prime.nix # prime offload
    ../../../../common/gpu/nvidia/ampere # use open drivers
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  boot.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    amdgpu.initrd.enable = false;

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      powerManagement.finegrained = lib.mkDefault true;
      prime = {
        amdgpuBusId = lib.mkDefault "PCI:52:0:0"; # Hexadecimal 34:00.0
        nvidiaBusId = lib.mkDefault "PCI:1:0:0"; # Hexadecimal 01:00.0
      };
    };
  };
}

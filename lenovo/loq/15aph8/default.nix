{ lib, ...}: {
  imports = [
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  hardware.nvidia.prime = {
    amdgpuBusId = lib.mkDefault "PCI:5:0:0";
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };

  # Power management - using mkDefault as these can be overridden
  hardware.nvidia.powerManagement.enable = lib.mkDefault true;
  hardware.nvidia.modesetting.enable = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;

  # These will merge with user settings, so no mkDefault needed
  hardware.amdgpu.initrd.enable = true;
}

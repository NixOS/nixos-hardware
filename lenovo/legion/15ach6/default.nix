{ lib, config, ... }:
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/hidpi.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:5:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.thermald.enable = lib.mkDefault true;

  # √(3840² + 2160²) px / 15.60 in ≃ 282 dpi
  services.xserver.dpi = 282;
}

{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/ampere
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/hidpi.nix
  ];

  # Specify bus id of Nvidia and Intel graphics.
  hardware.nvidia.prime = {
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # √(2560² + 1600²) px / 16 in ≃ 189 dpi
  services.xserver.dpi = 189;
}

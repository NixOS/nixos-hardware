{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Specify bus id of Nvidia and Intel graphics.
  hardware.nvidia.prime = {
    intelBusId = "PCI:00:02:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  # Cooling management
  services.thermald.enable = lib.mkDefault true;
}

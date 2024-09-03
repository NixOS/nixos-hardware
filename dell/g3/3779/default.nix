{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/pascal
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Specify bus id of Nvidia and Intel graphics
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # Use same ACPI identifier as Dell Ubuntu
  boot.kernelParams = [
    "acpi_osi=Linux-Dell-Video"
  ];
}

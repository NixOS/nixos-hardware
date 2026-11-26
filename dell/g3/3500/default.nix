{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/comet-lake
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
    ../../../common/pc/ssd
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

  # Goodix 27c6:530c fingerprint reader needs the proprietary TOD driver.
  services.fprintd = {
    enable = lib.mkDefault true;
    # Fingerprint sensor will not work without these settings
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-goodix;
  };
}

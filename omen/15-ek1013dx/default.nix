{ lib, pkgs, ... }:

{
  imports = [
    ../../common/cpu/intel/comet-lake
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/ampere
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # Enables ACPI platform profiles
  boot = lib.mkIf (lib.versionAtLeast pkgs.linux.version "6.1") {
    kernelModules = [ "hp-wmi" ];
  };

  # Enables Wifi and Bluetooth
  hardware.enableRedistributableFirmware = true;

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
}

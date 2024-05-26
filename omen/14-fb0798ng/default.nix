{ lib, pkgs, ... }:

{
  imports = [
    ../../common/cpu/intel
    ../../common/gpu/nvidia/prime.nix
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
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

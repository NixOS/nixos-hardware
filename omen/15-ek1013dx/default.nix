{ lib, pkgs, ... }:

{
  imports = [
    ../../common/cpu/intel/comet-lake
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/ampere
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
    ../../common/hidpi.nix
  ];

  # Enables ACPI platform profiles
  boot = lib.mkIf (lib.versionAtLeast pkgs.linux.version "6.1") {
    kernelModules = [ "hp-wmi" ];
  };

  # Since this is a laptop, enable the thermal daemon.
  # NOTE: Users may want to add lm-sensors and cpufreq-utils to system packages
  services.thermald.enable = lib.mkDefault true;

  # Enables Wifi and Bluetooth
  hardware.enableRedistributableFirmware = true;

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
}

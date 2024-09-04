{ lib, pkgs, ... }:

{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/gpu/nvidia/prime.nix
    ../../common/gpu/nvidia/turing
    ../../common/pc/laptop
    ../../common/pc/ssd
  ];

  # Enables ACPI platform profiles
  boot = lib.mkIf (lib.versionAtLeast pkgs.linux.version "6.1") {
    kernelModules = [ "hp-wmi" ];
  };

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:7:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

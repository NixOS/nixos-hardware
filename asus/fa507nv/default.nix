{ lib, pkgs, ... }:

{
    imports = [
      ../../common/cpu/amd
      ../../common/cpu/amd/raphael/igpu.nix
      ../../common/cpu/amd/pstate.nix
      ../../common/gpu/nvidia
      ../../common/gpu/nvidia/prime-sync.nix
      ../../common/hidpi.nix
      ../../common/pc/laptop
      ../../common/pc/ssd
    ];

    boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.6") pkgs.linuxPackages_latest;

    hardware.nvidia.prime = {
      amdgpuBusId = "PCI:54:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  }

{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Use latest LTS kernel for more Raphael fixes
  boot = lib.mkMerge [
    (lib.mkIf (lib.versionOlder pkgs.linux.version "6.6") {
      kernelPackages = pkgs.linuxPackages_6_6;
      kernelParams = ["amdgpu.sg_display=0"];
    })
  ];

  hardware.nvidia = {
      modesetting.enable = lib.mkDefault false;
      powerManagement.enable = lib.mkDefault false;
      powerManagement.finegrained = lib.mkDefault false;
      open = lib.mkDefault false;
      prime = {
          sync.enable = lib.mkDefault true;
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
      };
  };

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;
}

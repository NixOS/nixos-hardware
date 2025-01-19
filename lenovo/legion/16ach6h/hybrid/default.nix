{ lib, ... }:

{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/cpu/amd/zenpower.nix
    ../../../../common/gpu/amd
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/ampere
    ../../../../common/pc/laptop
    ../../../../common/pc/laptop/ssd
    ../edid
  ];

  # Still needs to load at some point if we want X11 to work
  boot.kernelModules = [ "amdgpu" ];

  # modesetting just doesn't work (on X11?), so get rid of it by only explicitly declaring nvidia
  # Needed due to https://github.com/NixOS/nixos-hardware/commit/630a8e3e4eea61d35524699f2f59dbc64886357d
  # See also https://github.com/NixOS/nixos-hardware/issues/628
  # options.services.xserver.drivers will have a amdgpu entry from using the prime stuff in nixpkgs
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    amdgpu.initrd.enable = false;

    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      dynamicBoost.enable = lib.mkDefault true;

      prime = {
        amdgpuBusId = lib.mkDefault "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}

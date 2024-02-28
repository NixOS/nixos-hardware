# Including this file will enable the NVidia driver, and PRIME offload

{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ../shared.nix
    ## "prime.nix" loads this, aleady:
    # ../../../../common/gpu/nvidia
    ../../../../../common/gpu/nvidia/prime.nix
  ];

  # NVIDIA GeForce RTX 3050 Mobile (Ampere)
  services.xserver.videoDrivers = mkDefault [ "nvidia" ];

  hardware = {
    ## Enable the Nvidia card, as well as Prime and Offload:
    amdgpu.loadInInitrd = true;
    opengl.extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];

    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement = {
        enable = true;
        # Doesn't seem to be reliable, yet?
        # finegrained = true
      };
    };
  };
}

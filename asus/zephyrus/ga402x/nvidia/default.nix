{ lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ../shared.nix
    ## "prime.nix" loads this, aleady:
    # ../../../common/gpu/nvidia
    ../../../../common/gpu/nvidia/prime.nix
  ];

  # NVIDIA GeForce RTX 4060 Mobile

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
  };

  # Also in nvidia/default.nix
  services.xserver.videoDrivers = mkDefault [ "nvidia" ];

  hardware = {
    ## Enable the Nvidia card, as well as Prime and Offload:
    amdgpu.loadInInitrd = true;
    opengl.extraPackages = with pkgs; [
      # Also in nvidia/default.nix
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
        amdgpuBusId = "PCI:101:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement = {
        # This is unreliable on the 4060;  works a few times, then hangs:
        # enable = true;
        # finegrained = true
      };
    };
  };
}

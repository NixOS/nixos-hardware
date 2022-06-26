{ lib, pkgs, ... }:

# This creates a new 'nvidia-offload' program that runs the application passed to it on the GPU
# As per https://nixos.wiki/wiki/Nvidia
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  environment.systemPackages = [ nvidia-offload ];

  hardware.nvidia.prime = {
    offload.enable = lib.mkDefault true;
    # Hardware should specify the bus ID for intel/nvidia devices
  };

  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
  ];
}

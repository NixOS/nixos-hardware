{ lib, ... }:

{
  imports = [
    ../.
    ../../../../common/gpu/nvidia/blackwell
    ../../../../common/gpu/nvidia/prime.nix
  ];

  # Explicitly set nvidia as video driver to override modesetting from AMD module
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Hybrid graphics with PRIME offload for better battery life
    # AMD iGPU by default, NVIDIA dGPU on demand via nvidia-offload command
    prime = {
      # WARNING: These defaults may not match your system!
      # Bus IDs vary depending on installed expansion cards and NVMe drives.
      # You MUST override these values - see README.md for instructions.
      # Bus IDs can be found with `lspci | grep -E "VGA|3D|Display"`
      amdgpuBusId = lib.mkDefault "PCI:195:0:0";
      nvidiaBusId = lib.mkDefault "PCI:194:0:0";
    };

    # Power management for hybrid graphics
    powerManagement.enable = lib.mkDefault true;
  };
}

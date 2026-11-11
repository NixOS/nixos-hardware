{ lib, config, ... }:

{
  imports = [
    ../../common/cpu/intel
    ../../common/gpu/nvidia/prime.nix
    ../../common/pc/laptop
    ../../common/pc/laptop/ssd
  ];

  # System76 Oryx Pro with RTX 3070 Ti
  # This configuration is for laptops with:
  # - Intel Alder Lake-P CPU with Iris Xe iGPU
  # - NVIDIA GeForce RTX 3070 Ti Laptop GPU (GA104 - Ampere)
  # - Hybrid graphics with HDMI output connected to NVIDIA GPU

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    # Enable graphics support
    graphics.enable = lib.mkDefault true;

    nvidia = {
      # Modesetting is required for Wayland support
      modesetting.enable = lib.mkDefault true;

      # Use production driver (recommended for stability)
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.production;

      # Use open source kernel modules (recommended for RTX 30 series)
      open = lib.mkDefault true;

      # Enable nvidia-settings GUI
      nvidiaSettings = lib.mkDefault true;

      # PRIME configuration for hybrid graphics
      prime = {
        # Use sync mode for external display support via HDMI
        # Note: This uses more power but enables HDMI output
        sync.enable = lib.mkDefault true;

        # Bus IDs for Intel and NVIDIA GPUs
        # These are standard for Oryx Pro models with this configuration
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      # Power management for better battery life
      powerManagement = {
        enable = lib.mkDefault true;
        finegrained = lib.mkDefault false;  # Disabled in sync mode
      };
    };
  };

  # Wayland-specific NVIDIA environment variables for better compatibility
  environment.sessionVariables = {
    # Fix cursor issues on Wayland
    WLR_NO_HARDWARE_CURSORS = "1";
    # NVIDIA-specific variables for proper rendering
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # Additional kernel parameters for NVIDIA stability
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # System76 firmware support
  hardware.system76.enableAll = lib.mkDefault true;
}
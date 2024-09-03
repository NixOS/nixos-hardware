{ lib, pkgs, ... }: {
  imports = [
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/ampere
  ];

  #D-Bus service to check the availability of dual-GPU
  services.switcherooControl.enable = lib.mkDefault true;

  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
      extraPackages = with pkgs; [ intel-media-driver intel-compute-runtime ];
    };
    nvidia = {
      prime = {
        # Bus ID of the Intel GPU.
        intelBusId = lib.mkDefault "PCI:0:2:0";
        # Bus ID of the NVIDIA GPU.
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      };
      powerManagement = {
        # Enable NVIDIA power management.
        enable = lib.mkDefault true;

        # Enable dynamic power management.
        finegrained = lib.mkDefault true;
      };
    };
  };
}

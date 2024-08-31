{lib, ...}:
{
  imports = [
    ../.
    ../../../../common/gpu/nvidia/prime.nix
    ../../../../common/gpu/nvidia/turing
  ];

  hardware.nvidia = {
    powerManagement = {
      # Enable NVIDIA power management.
      enable = lib.mkDefault true;

      # Enable dynamic power management.
      finegrained = lib.mkDefault true;
    };

    prime = {
      # Bus ID of the Intel GPU.
      intelBusId = lib.mkDefault "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU.
      nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    };
  };
}

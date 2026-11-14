{ lib, ... }:
{
  imports = [
    ../.
    ../../../../../common/gpu/nvidia/ampere
    ../../../../../common/gpu/nvidia/prime.nix
  ];

  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
    nvidia = {
      # "Wayland requires kernel mode setting (KMS) to be enabled (Highly
      # Recommended)" per https://wiki.nixos.org/wiki/NVIDIA#Requirements.
      modesetting.enable = lib.mkDefault true;
      prime = {
        # Bus ID of the Intel GPU.
        intelBusId = lib.mkDefault "PCI:0:2:0";
        # Bus ID of the NVIDIA GPU.
        nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      };
    };
  };
}

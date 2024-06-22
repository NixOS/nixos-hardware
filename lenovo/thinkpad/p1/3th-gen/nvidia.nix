{ lib, ... }:
{
  imports = [
    ../../../../common/gpu/24.05-compat.nix
  ];
  hardware = {
    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };
    nvidia = {
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

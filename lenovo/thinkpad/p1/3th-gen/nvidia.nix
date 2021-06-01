{ lib, pkgs, ... }:
{
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;

  hardware.nvidia.prime = {
    # Bus ID of the Intel GPU.
    intelBusId = lib.mkDefault "PCI:0:2:0";
    # Bus ID of the NVIDIA GPU.
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}

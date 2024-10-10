{ lib, ... }:
{
  imports = [
    ../../../common/gpu/nvidia
  ];

  # or even better: boot.kernelParams = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "i915.force_probe=7d55" ];

  hardware.nvidia.open = true;
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

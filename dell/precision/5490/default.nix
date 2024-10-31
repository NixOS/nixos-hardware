{ config, lib, ... }:
{
  imports = [
    ../../../common/gpu/nvidia/ada-lovelace
  ];

  boot.kernelParams = lib.mkIf (lib.versionOlder config.boot.kernelPackages.kernel.version "6.7") [ "i915.force_probe=7d55" ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

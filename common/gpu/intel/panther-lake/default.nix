{ config, lib, ... }:
{
  imports = [ ../. ];
  hardware.intelgpu = {
    driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.17") "xe";
    vaapiDriver = "intel-media-driver";
  };
}

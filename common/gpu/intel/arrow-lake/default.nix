{ config, lib, ... }:
{
  imports = [ ../. ];
  hardware.intelgpu = {
    driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") "xe";
    vaapiDriver = "intel-media-driver";
  };
}

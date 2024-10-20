{ config, lib, ... }:
{
  imports = [ ../. ];
  config = {
    hardware.intelgpu.driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") "xe";
    boot.kernelParams = lib.mkIf (config.hardware.intelgpu.driver == "i915") [ "i915.enable_guc=3" ];
    hardware.intelgpu.vaapiDriver = "intel-media-driver";
  };
}

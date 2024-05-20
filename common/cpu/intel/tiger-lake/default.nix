{ config, lib, ... }:
{
  imports = [ ../. ];
  config = lib.mkMerge [
    (lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") {
      hardware.intelgpu.driver = "xe";
    })
    (lib.mkIf (config.hardware.intelgpu.driver == "i915") {
      boot.kernelParams = [ "i915.enable_guc=3" ];
    })
  ];
}

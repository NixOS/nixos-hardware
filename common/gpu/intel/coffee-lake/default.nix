{ ... }:

{
  imports = [ ../. ];

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  hardware.intelgpu = {
    computeRuntime = "legacy";
    vaapiDriver = "intel-media-driver";
  };
}

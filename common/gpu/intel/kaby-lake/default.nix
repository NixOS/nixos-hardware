{
  imports = [ ../. ];

  boot.kernelParams = [
    "i915.enable_guc=2"
    "i915.enable_fbc=1"
    "i915.enable_psr=2"
  ];

  hardware.intelgpu.vaapiDriver = "intel-media-driver";
}

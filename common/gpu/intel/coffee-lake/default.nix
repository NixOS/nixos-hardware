{ ... }:

{
  imports = [ ../. ];

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  hardware.intelgpu.vaapiDriver = "intel-media-driver";
}

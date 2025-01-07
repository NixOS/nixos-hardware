{ ... }:
{
  # These flags are used to enable backlight control when the dGPU is working in hybrid mode
  boot.kernelParams = [
    "i915.enable_dpcd_backlight=1"
    "nvidia.NVreg_EnableBacklightHandler=0"
    "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
  ];
}

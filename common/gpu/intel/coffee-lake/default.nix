{ ... }:

{
  imports = [ ../. ];

  hardware.intelgpu = {
    driver = "i915";
    vaapiDriver = "intel-media-driver";
  };
}

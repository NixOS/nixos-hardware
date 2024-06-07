{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  boot.kernelParams = [
    # See https://discourse.nixos.org/t/i915-driver-has-bug-for-iris-xe-graphics/25006/12
    # jheidbrink reports that without this setting there is a very high lag in Sway which makes it unusable
    "i915.enable_psr=0"
  ];

  # Make the webcam work (needs Linux >= 6.6):
  hardware.ipu6.enable = true;
  hardware.ipu6.platform = "ipu6ep";
}

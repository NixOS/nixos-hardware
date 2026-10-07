{ lib, ... }:

{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/amd
    ../../common/pc/ssd
  ];

  boot.kernelParams = [
    # Native LCD panel is portrait.
    "fbcon=rotate:1"
    # Display-core flicker on Jupiter.
    "amdgpu.dcdebugmask=0x10"
    "amdgpu.dc=1"
  ];

  # Handheld gyro / accelerometer.
  hardware.sensor.iio.enable = lib.mkDefault true;
}

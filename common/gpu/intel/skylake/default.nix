{ pkgs, ... }:

{
  imports = [ ../. ];

  boot.kernelParams = [
    "i915.enable_guc=2"
  ];

  # VP9 decoding not supported when using intel-media-driver
  # https://github.com/intel/media-driver/issues/1024
  # NixOS Wiki recommends using the legacy intel-vaapi-driver with the hybrid codec over that one for Skylake.
  # https://wiki.nixos.org/wiki/Accelerated_Video_Playback
  hardware.intelgpu = {
    vaapiDriver = "intel-vaapi-driver";
    enableHybridCodec = true;
  };
}

{
  imports = [
    ./cpu-only.nix
    ../../../gpu/intel/comet-lake
  ];

  hardware.intelgpu.vaapiDriver = "intel-media-driver";
}

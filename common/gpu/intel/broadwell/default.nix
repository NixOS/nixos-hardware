{
  imports = [ ../. ];

  hardware.intelgpu = {
    computeRuntime = "legacy";
    vaapiDriver = "intel-vaapi-driver";
    enableHybridCodec = true;
  };
}

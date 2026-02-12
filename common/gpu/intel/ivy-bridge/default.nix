{
  imports = [ ../. ];

  hardware.intelgpu = {
    vaapiDriver = "intel-vaapi-driver";
    enableHybridCodec = true;
  };
}

{ lib, pkgs, ... }:

{
  imports = [ ../. ];

  hardware.intelgpu = {
    vaapiDriver = "intel-vaapi-driver";
    enableHybridCodec = true;
  };
}

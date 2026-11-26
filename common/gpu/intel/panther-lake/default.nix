{ config, lib, ... }:
let
  cfg = config.hardware.intelgpu;
in
{
  imports = [ ../. ];

  # i915 does not support Panther Lake (Xe3) graphics.
  # xe supports it without force_probe since Linux 6.17.
  hardware.intelgpu = {
    driver = lib.mkDefault "xe";
    vaapiDriver = lib.mkDefault "intel-media-driver";
  };

  # The GSC (a security controller in the GPU) talks to the CSME through xe and mei_gsc_proxy,
  # but xe waits only 20 seconds for mei_gsc_proxy module and does not try again.
  # If mei_gsc_proxy is not in the initrd with xe, GSC init stops, and HDCP 2.x and PXP fail.
  boot.initrd.kernelModules = lib.mkIf (cfg.loadInInitrd && cfg.driver == "xe") [
    "mei_me"
    "mei_gsc_proxy"
  ];
}

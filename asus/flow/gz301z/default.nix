{
  lib,
  ...
}:

let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../../common/cpu/intel/alder-lake
    ../../../common/gpu/intel/alder-lake
    ../../../common/gpu/nvidia/ampere
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [
      # Panel self-refresh causes flicker / black frames on this eDP.
      "i915.enable_psr=0"
    ];
  };

  services = {
    asusd.enable = mkDefault true;
    # Enable the daemon only. Do not pin AsusMuxDgpu: that is dGPU-display
    # mode and fights NVIDIA PRIME offload (hybrid / iGPU display).
    supergfxd.enable = mkDefault true;
  };

  # 2-in-1: accelerometer / tablet orientation.
  hardware.sensor.iio.enable = mkDefault true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = mkDefault true;

    prime = {
      offload = {
        enable = mkDefault true;
        enableOffloadCmd = mkDefault true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    powerManagement = {
      enable = mkDefault true;
      finegrained = mkDefault false;
    };

    dynamicBoost.enable = mkDefault true;
  };
}

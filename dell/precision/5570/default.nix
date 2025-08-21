{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/alder-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/gpu/nvidia/prime.nix
  ];

  hardware.intelgpu.driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") "xe";

  boot.kernelParams = lib.mkIf (config.hardware.intelgpu.driver == "xe") [
    "i915.force_probe=!46a6"
    "xe.force_probe=46a6"
  ];

  hardware.nvidia = {
    nvidiaSettings = lib.mkDefault true;
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Override the Intel gpu driver setting imported above
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkOverride 990 "nvidia");
  };

  services.thermald.enable = lib.mkDefault true;
}

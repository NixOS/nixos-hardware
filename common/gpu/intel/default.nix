{ config, lib, pkgs, ... }:

{
  options.hardware.intelgpu.loadInInitrd = lib.mkEnableOption (lib.mdDoc
    "loading `i195` kernelModule at stage 1. (Add `i915` to `boot.initrd.kernelModules`)"
  ) // {
    default = true;
  };

  config = lib.mkMerge [
    (lib.mkIf config.hardware.intelgpu.loadInInitrd { 
      boot.initrd.kernelModules = [ "i915" ]; 
    })
    {
      environment.variables = {
        VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
      };

      hardware.opengl.extraPackages = with pkgs; [
        (if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then vaapiIntel else intel-vaapi-driver)
        libvdpau-va-gl
        intel-media-driver
      ];
    }
  ];
}

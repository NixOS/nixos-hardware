{ config, lib, pkgs, ... }:

{
  options.hardware.amdgpu.loadInInitrd = lib.mkEnableOption (lib.mdDoc 
    "loading `amdgpu` kernelModule at stage 1. (Add `amdgpu` to `boot.initrd.kernelModules`)"
  ) // {
    default = true;
  };

  config = lib.mkMerge [
    {
      services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" ];
  
      hardware.opengl.extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];

      hardware.opengl.extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];

      hardware.opengl = {
        driSupport = lib.mkDefault true;
        driSupport32Bit = lib.mkDefault true;
      };

      environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";
    }
    (lib.mkIf config.hardware.amdgpu.loadInInitrd {
      boot.initrd.kernelModules = [ "amdgpu" ];
    })
  ];
} 

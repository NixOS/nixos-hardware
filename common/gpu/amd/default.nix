{ config, lib, pkgs, ... }:

{
  options.hardware.amdgpu.loadInInitrd = lib.mkEnableOption (lib.mdDoc 
    "loading `amdgpu` kernelModule at stage 1. (Add `amdgpu` to `boot.initrd.kernelModules`)"
  ) // {
    default = true;
  };
  options.hardware.amdgpu.amdvlk = lib.mkEnableOption (lib.mdDoc 
    "use amdvlk drivers instead mesa radv drivers"
  ) // {
    default = true;
  };
  options.hardware.amdgpu.opencl = lib.mkEnableOption (lib.mdDoc 
    "rocm opencl runtime (Install rocm-opencl-icd and rocm-opencl-runtime)"
  ) // {
    default = true;
  };

  config = lib.mkMerge [
    {
      services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" ];

      hardware.opengl = {
        driSupport = lib.mkDefault true;
        driSupport32Bit = lib.mkDefault true;
      };
    }
    (lib.mkIf config.hardware.amdgpu.loadInInitrd {
      boot.initrd.kernelModules = [ "amdgpu" ];
    })
    (lib.mkIf config.hardware.amdgpu.amdvlk {
      hardware.opengl.extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];

      hardware.opengl.extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      
      environment.variables.AMD_VULKAN_ICD = lib.mkDefault "RADV";
    })
    (lib.mkIf config.hardware.amdgpu.opencl {
      hardware.opengl.extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    })
  ];
} 

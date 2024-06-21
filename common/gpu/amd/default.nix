{ config, lib, pkgs, ... }:

{
  options.hardware.amdgpu.loadInInitrd = lib.mkEnableOption (lib.mdDoc
    "loading `amdgpu` kernelModule at stage 1. (Add `amdgpu` to `boot.initrd.kernelModules`)"
  ) // {
    default = true;
  };

  imports = [ ../24.05-compat.nix ];
  config = lib.mkMerge [
    {
      services.xserver.videoDrivers = lib.mkDefault [ "modesetting" ];

      hardware.graphics = {
        enable = lib.mkDefault true;
        enable32Bit = lib.mkDefault true;
      };
    }
    (lib.mkIf config.hardware.amdgpu.loadInInitrd {
      boot.initrd.kernelModules = [ "amdgpu" ];
    })
  ];
}

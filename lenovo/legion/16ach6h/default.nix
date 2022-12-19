{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ./edid
  ];

  config = lib.mkMerge [
    {
      hardware.amdgpu.loadInInitrd = lib.mkDefault false;

      hardware.nvidia = {
        modesetting.enable = lib.mkDefault true;
        powerManagement.enable = lib.mkDefault true;
      };
      
      services.thermald.enable = lib.mkDefault true;

      specialisation.ddg.configuration = {
        # This specialisation is for the case where "DDG" (A hardware feature that can enable in bios) is enabled, since the amd igpu is blocked at hardware level and the built-in display is directly connected to the dgpu, we no longer need the amdgpu and prime configuration.
        services.xserver.videoDrivers = [ "nvidia" ]; # This will override services.xserver.videoDrivers = lib.mkDefault [ "amdgpu" "nvidia" ];
        hardware.nvidia.prime.offload.enable = false;
      };
    }

    (lib.mkIf (config.specialisation != {}) {
      hardware.nvidia.prime = {
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    })
  ];
}
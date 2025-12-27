{ config, lib, ... }: 
{
  imports = [
    ../../common/cpu/amd
    ../../common/cpu/amd/pstate.nix
    ../../common/gpu/nvidia
    ../../common/pc/laptop
    ../../common/pc/ssd
    ../battery.nix
  ];

  hardware.nvidia = {
    modesetting.enable = lib.mkDefault true;
    open = lib.mkIf (lib.versionAtLeast config.hardware.nvidia.package.version "555") true;
  };
}

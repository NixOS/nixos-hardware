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
    open = lib.mkDefault false;
  };

  services = {
    asusd = {
      enable = lib.mkDefault true;
      enableUserService = lib.mkDefault true;
    };
    supergfxd.enable = lib.mkDefault true;
  };
}

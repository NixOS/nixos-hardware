{ lib, pkgs, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../common.nix
  ];


  # This runs only nvidia, great for games or heavy use of render applications

  ##### disable intel, run nvidia only and as default
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  hardware.nvidia.modesetting.enable = lib.mkDefault true;
  hardware.nvidia.prime = {
    enable = lib.mkDefault true;
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
    intelBusId = lib.mkDefault "PCI:0:2:0";
  }
}

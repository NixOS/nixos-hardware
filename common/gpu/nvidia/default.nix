{ lib, pkgs, ... }:

{
  imports = [ ../24.05-compat.nix ];
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  hardware.graphics.extraPackages = [
    (
      if pkgs ? libva-vdpau-driver
      then pkgs.libva-vdpau-driver
      else pkgs.vaapiVdpau
    )
  ];
}

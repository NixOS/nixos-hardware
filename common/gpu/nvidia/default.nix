{ lib, pkgs, ... }:

{
  imports = [ ../24.05-compat.nix ];
  services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];
  hardware.graphics.extraPackages = with pkgs; [
    vaapiVdpau
  ];
}

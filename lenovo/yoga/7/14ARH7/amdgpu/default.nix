# Including this file will enable the AMD-GPU driver

{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ../shared.nix
  ];

  # AMD RX680
  services.xserver.videoDrivers = mkDefault [ "amdgpu" ];

  hardware = {
    amdgpu.loadInInitrd = true;
    opengl.extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}

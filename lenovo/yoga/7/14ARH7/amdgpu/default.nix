# Including this file will enable the AMD-GPU driver

{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ../shared.nix
    ../../../../../common/gpu/24.05-compat.nix
  ];

  # AMD RX680
  services.xserver.videoDrivers = mkDefault [ "amdgpu" ];

  hardware = {
    amdgpu.loadInInitrd = true;
    graphics.extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}

{ lib, pkgs, ... }:

{
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
}

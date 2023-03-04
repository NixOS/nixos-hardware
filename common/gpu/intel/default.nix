{ config, lib, pkgs, ... }:
let 
  selectPackages = pkgs: with pkgs; [
    intel-media-driver
    vaapiIntel
  ];
in
{
  boot.initrd.kernelModules = [ "i915" ];

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  hardware.opengl.extraPackages = selectPackages pkgs;
  hardware.opengl.extraPackages32 = selectPackages (pkgs.driversi686Linux);
}

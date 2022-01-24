{ config, pkgs, lib, ... }:
with lib;
let
  xcfg = config.services.xserver;
  cfg = config.hardware.hp.elitebook.graphics;
in
{
  options.hardware.hp.elitebook.graphics = {
    enable = mkOption {
      default = xcfg.enable;
      example = !xcfg.enable;
      description = "Wether to enable iGPU related settings for HP Elitebook laptops";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [ "i915" ];
    hardware.opengl = {
      enable = mkDefault true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
      ];
    };
  };
}
      

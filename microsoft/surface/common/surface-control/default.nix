{ config, lib, pkgs, ... }:


let
  inherit (lib) mkDefault mkEnableOption mkIf mkMerge;

  cfg = config.microsoft-surface.surface-control;

in {
  options.microsoft-surface.surface-control = {
    enable = mkEnableOption "Enable 'surface-control' for Microsoft Surface";
  };

  config = mkMerge [
    {
      microsoft-surface.surface-control.enable = mkDefault false;
    }

    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [ surface-control ];
      services.udev.packages = with pkgs; [ surface-control];
      users.groups.surface-control = { };
    })
  ];
}

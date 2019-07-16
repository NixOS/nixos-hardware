{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.hardware.samus.cmt;
in

{
  options.hardware.samus.cmt = {
    enable = mkEnableOption "Use Chrome Multitouch input (cmt)";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.modules = [ pkgs.xf86-input-cmt ];

    environment.etc."X11/xorg.conf.d/40-touchpad-cmt.conf".source =
      "${pkgs.chromium-xorg-conf}/40-touchpad-cmt.conf";

    environment.etc."X11/xorg.conf.d/50-touchpad-cmt-samus.conf".source =
      "${pkgs.chromium-xorg-conf}/50-touchpad-cmt-samus.conf";
  };
}

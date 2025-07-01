{ config, lib, ... }:
let
  cfg = config.hardware.raspberry-pi."4".apply-overlays-dtmerge;
  dt_ao_overlay = _final: prev: {
    deviceTree = prev.deviceTree // {
      applyOverlays = _final.callPackage ./apply-overlays-dtmerge.nix { };
    };
  };
in
{
  options.hardware = {
    raspberry-pi."4".apply-overlays-dtmerge = {
      enable = lib.mkEnableOption ''
        replace deviceTree.applyOverlays implementation to use dtmerge from libraspberrypi.
        this can resolve issues with applying dtbs for the pi.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ dt_ao_overlay ];
  };
}

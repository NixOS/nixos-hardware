{ config, lib, pkgs, modulesPath, ... }:
let
  callPackage = path: overrides:
    let f = import path;
    in f ((builtins.intersectAttrs (builtins.functionArgs f) pkgs) // overrides);
  cfg = config.hardware.raspberry-pi."4".apply-overlays-dtmerge;
  dt_ao_overlay = (final: prev: {
    deviceTree.applyOverlays = (prev.callPackage ./apply-overlays-dtmerge.nix { }).applyOverlays;
  });
in {
  options.hardware = {
    raspberry-pi."4".apply-overlays-dtmerge = {
      enable = lib.mkEnableOption ''
        replace deviceTree.applyOverlays implementation to use dtmerge from libraspberrypi.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ dt_ao_overlay ];
  };
}

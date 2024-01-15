{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage2 surfacePatches;

  cfg = config.microsoft-surface;

  version = "6.6.10";
  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./patches.nix;
  };
  kernelPackages = linuxPackage2 {
    inherit version kernelPatches;
    sha256 = "sha256-nuYn5MEJrsf8o+2liY6B0gGvLH6y99nX2UwfDhIFVGw=";
  };

in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ version majorVersion ];
  };

  config = mkIf (cfg.kernelVersion == version) {
    boot = {
      inherit kernelPackages;
    };
  };
}

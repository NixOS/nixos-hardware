{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage surfacePatches;

  cfg = config.microsoft-surface;

  version = "6.6.13";
  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./patches.nix;
  };
  kernelPackages = linuxPackage {
    inherit version kernelPatches;
    sha256 = "sha256-iLiefdQerU46seQRyLuNWSV1rPgVzx3zwNxX4uiCwLw=";
    ignoreConfigErrors=true;
  };

in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ version ];
  };

  config = mkIf (cfg.kernelVersion == version) {
    boot = {
      inherit kernelPackages;
    };
  };
}

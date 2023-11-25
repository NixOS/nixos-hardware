{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage2 surfacePatches;

  cfg = config.microsoft-surface;

  version = "6.6.2";
  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./patches.nix;
  };
  kernelPackages = linuxPackage2 {
    inherit version kernelPatches;
    sha256 = "sha256-c9T2rY3WrCpB7VLCkoiYt8PyUZ7V29sRkgIJo2mZt34=";
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

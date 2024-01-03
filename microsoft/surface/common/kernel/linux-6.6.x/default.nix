{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage2 surfacePatches;

  cfg = config.microsoft-surface;

  version = "6.6.8";
  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./patches.nix;
  };
  kernelPackages = linuxPackage2 {
    inherit version kernelPatches;
    sha256 = "sha256-UDbENOEeSzbY2j9ImFH3+CnPeF+n94h0aFN6nqRXJBY=";
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

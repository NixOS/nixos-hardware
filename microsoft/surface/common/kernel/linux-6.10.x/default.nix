{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage surfacePatches isVersionOf versionsOfEnum;

  cfg = config.microsoft-surface;

  version = "6.10.5";
  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./patches.nix;
  };
  kernelPackages = linuxPackage {
    inherit version kernelPatches;
    sha256 = "02yckkh6sxvcrwzbqgmw4jhqhxmbvz87xn9wm6bwwka3w2r9x41h";
    ignoreConfigErrors=true;
  };

in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = versionsOfEnum version;
  };

  config = mkIf (isVersionOf cfg.kernelVersion version) {
    boot = {
      inherit kernelPackages;
    };
  };
}

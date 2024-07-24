{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage surfacePatches isVersionOf versionsOfEnum;

  cfg = config.microsoft-surface;

  version = "6.9.9";
  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./patches.nix;
  };
  kernelPackages = linuxPackage {
    inherit version kernelPatches;
    sha256 = "1f8y88rif3z5lp1bq00g66fd0xs1227qlqkxd2zs6fdjgr45pq1b";
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

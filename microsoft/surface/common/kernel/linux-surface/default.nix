{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage surfacePatches isVersionOf versionsOfEnum;

  cfg = config.microsoft-surface;

  version = "6.12.17";
  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./patches.nix;
  };
  kernelPackages = linuxPackage {
    inherit version kernelPatches;
    sha256 = "sha256-XCBc00+Al05Jc+MhywCPX2iVqKqMJXfwapRIzXfeY7M=";
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

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface;

  version = "6.6.8";
  majorVersion = "6.6";
  patchDir = repos.linux-surface + "/patches/${majorVersion}";
  kernelPatches = pkgs.callPackage ./patches.nix {
    inherit (lib) kernel;
    inherit version patchDir;
  };

  kernelPackages = linuxPackage {
    inherit version kernelPatches;
    extraMeta.branch = majorVersion;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
      sha256 = "sha256-UDbENOEeSzbY2j9ImFH3+CnPeF+n94h0aFN6nqRXJBY=";
    };
  };


in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ version majorVersion ];
  };

  config = mkIf (cfg.kernelVersion == version || cfg.kernelVersion == majorVersion) {
    boot = {
      inherit kernelPackages;
    };
  };
}

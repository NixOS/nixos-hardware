{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage1 repos;

  cfg = config.microsoft-surface;

  version = "6.1.62";
  extraMeta.branch = "6.1";
  patchSrc = repos.linux-surface + "/patches/${extraMeta.branch}";
  kernelPatches = pkgs.callPackage ./patches.nix {
    inherit (lib) kernel;
    inherit version patchSrc;
  };

  kernelPackages = linuxPackage1 {
    inherit version extraMeta kernelPatches;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
      sha256 = "sha256-uf1hb6zWvs/O74i5vnGNDxZiXKs/6B0ROEgCpwkehew=";
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

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface;

  version = "6.4.12";
  extraMeta.branch = "6.4";
  patchDir = repos.linux-surface + "/patches/${extraMeta.branch}";
  kernelPatches = pkgs.callPackage ./patches.nix {
    inherit (lib) kernel;
    inherit version patchDir;
  };

  kernelPackages = linuxPackage {
    inherit version extraMeta kernelPatches;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
      sha256 = "0x56b4hslm730ghvggz41fjkbzlnxp6k8857dn7iy27yavlipafc";
    };
  };


in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ "6.4.12" ];
  };

  config = mkIf (cfg.kernelVersion == "6.4.12") {
    boot = {
      inherit kernelPackages;
    };
  };
}

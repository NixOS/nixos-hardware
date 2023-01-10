{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface;

  version = "5.19.17";
  extraMeta.branch = "5.19";
  patchDir = repos.linux-surface + "/patches/${extraMeta.branch}";
  kernelPatches = pkgs.callPackage ./patches.nix {
    inherit (lib) kernel;
    inherit version patchDir;
  };

  kernelPackages = linuxPackage {
    inherit version extraMeta kernelPatches;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
      sha256 = "sha256-yTuzhKl60fCk8Y5ELOApEkJyL3gCPspliyI0RUHwlIk=";
    };
  };

in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ "5.19.17" ];
  };

  config = mkIf (cfg.kernelVersion == "5.19.17") {
    boot = {
      inherit kernelPackages;
    };
  };
}

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface;

  version = "6.0.11";
  extraMeta.branch = "6.0";
  patchDir = repos.linux-surface + "/patches/${extraMeta.branch}";
  kernelPatches = pkgs.callPackage ./patches.nix {
    inherit (lib) kernel;
    inherit version patchDir;
  };

  kernelPackages = linuxPackage {
    inherit version extraMeta kernelPatches;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
      sha256 = "sha256-K65hMeZJceHjT/OV+lQpcRNMhXvbCykGmrhHx8mpx2I=";
    };
  };


in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ "6.0.11" ];
  };

  config = mkIf (cfg.kernelVersion == "6.0.11") {
    boot = {
      inherit kernelPackages;
    };
  };
}

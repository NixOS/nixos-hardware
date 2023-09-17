{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface;

  version = "6.4.16";
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
      sha256 = "0zgj1z97jyx7wf12zrnlcp0mj4cl43ais9qsy6dh1jwylf2fq9ln";
    };
  };


in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ "6.4.16" ];
  };

  config = mkIf (cfg.kernelVersion == "6.4.16") {
    boot = {
      inherit kernelPackages;
    };
  };
}

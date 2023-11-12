{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface;

  version = "6.5.11";
  extraMeta.branch = "6.5";
  patchDir = repos.linux-surface + "/patches/${extraMeta.branch}";
  kernelPatches = pkgs.callPackage ./patches.nix {
    inherit (lib) kernel;
    inherit version patchDir;
  };

  kernelPackages = linuxPackage {
    inherit version extraMeta kernelPatches;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
      sha256 = "sha256-LuJK+SgrgJI7LaVrcKrX3y6O5OPwdkUuBbpmviBZtRk=";
    };
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

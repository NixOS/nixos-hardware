{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface;

  version = "6.5.5";
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
      sha256 = "15gg8sb6cfgk1afwj7fl7mj4nkj14w43vzwvw0qsg3nzyxwh7wcc";
    };
    ignoreConfigErrors = true;
  };


in {
  options.microsoft-surface.kernelVersion = mkOption {
    type = types.enum [ "6.5.5" ];
  };

  config = mkIf (cfg.kernelVersion == "6.5.5") {
    boot = {
      inherit kernelPackages;
    };
  };
}

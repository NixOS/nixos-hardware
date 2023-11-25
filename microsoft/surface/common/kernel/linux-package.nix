{ pkgs,
  lib,
  fetchurl,
  buildLinux,
  linuxPackagesFor,
}:

let
  inherit (lib) recurseIntoAttrs versions;
  repos = pkgs.callPackage ../repos.nix {};

  # Version 1 of the linuxPackage function:
  # (DEPRECATED)
  linuxPackage1 =
    { version,
      modDirVersion ? version,
      ...
    } @ args:
    let
      buildLinux' = buildLinux (args // { inherit modDirVersion; });
      linuxPackagesFor' = linuxPackagesFor buildLinux';
    in recurseIntoAttrs linuxPackagesFor';

  # Version 1 of the linuxPackage funtion, with hopefully simplified arguments:
  linuxPackage2 =
    { url ? "mirror://kernel/linux/kernel/v${versions.major version}.x/linux-${version}.tar.xz",
      sha256 ? null,
      src ? (fetchurl { inherit url sha256; }),
      version,
      modDirVersion ? (versions.pad 3 version),
      kernelPatches ? [],
      ...
    } @ args: let
      inherit (builtins) removeAttrs;

      args' = {
        inherit src version modDirVersion kernelPatches;
      } // removeAttrs args [ "url" "sha256" ];
      linuxPackage = buildLinux args';
      linuxPackages' = recurseIntoAttrs (linuxPackagesFor linuxPackage);
    in linuxPackages';

  surfacePatches =
    { patchSrc ? (repos.linux-surface + "/patches/${versions.major version}"),
      version,
      patchFn,
    }: pkgs.callPackage patchFn {
      inherit (lib) kernel;
      inherit version patchSrc;
    };

in {
  inherit linuxPackage1 linuxPackage2 repos surfacePatches;

  # Default version:
  linuxPackage = linuxPackage2;
}

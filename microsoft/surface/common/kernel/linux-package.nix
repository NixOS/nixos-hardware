{ pkgs,
  lib,
  fetchurl,
  buildLinux,
  linuxPackagesFor,
}:

let
  inherit (lib) recurseIntoAttrs versions;
  repos = pkgs.callPackage ../repos.nix {};

  linuxPackage =
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
    { patchSrc ? (repos.linux-surface + "/patches/${versions.majorMinor version}"),
      version,
      patchFn,
    }: pkgs.callPackage patchFn {
      inherit (lib) kernel;
      inherit version patchSrc;
    };

in {
  inherit linuxPackage repos surfacePatches;
}

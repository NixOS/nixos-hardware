{ pkgs,
  lib,
  fetchurl,
  buildLinux,
  linuxPackagesFor,
}:

let
  inherit (builtins) elem;
  inherit (lib) recurseIntoAttrs types versions;

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

  versionsOf = version:
    # Provides a list of versions that can be used as an enum option for this full version:
    [ version (versions.majorMinor version) ];

  versionsOfEnum = version:
    # Provide an enum option for versions of this kernel:
    types.enum (versionsOf version);

  isVersionOf = kernelVersion: version:
    # Test if the provided version is considered one of the list of versions from above:
    elem kernelVersion (versionsOf version);

in {
  inherit linuxPackage repos surfacePatches versionsOf isVersionOf versionsOfEnum;
}

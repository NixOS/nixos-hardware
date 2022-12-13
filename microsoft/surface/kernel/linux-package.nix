{ lib,
  buildLinux,
  callPackage,
  fetchurl,
  linuxPackagesFor,
}:

let
  inherit (lib) kernel recurseIntoAttrs;

in {
  repos = callPackage ../repos.nix {};

  linuxPackage =
    { version,
      modDirVersion ? version,
      ...
    } @ args:
    let
      buildLinux' = buildLinux (args // { inherit modDirVersion; });
      linuxPackagesFor' = linuxPackagesFor buildLinux';
    in recurseIntoAttrs linuxPackagesFor';
}

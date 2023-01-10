{ lib,
  buildLinux,
  callPackage,
  linuxPackagesFor,
}:

let
  inherit (lib) recurseIntoAttrs;

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

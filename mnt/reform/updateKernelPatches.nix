let
  privateInputs =
    (import ../../tests/flake-compat.nix {
      src = ../../tests;
    }).defaultNix;
  nixpkgs = privateInputs.nixos-unstable-small;
  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
  lib = nixpkgs.lib;
  sources = lib.importJSON ./sources.json;
  reformDebianPackages = pkgs.fetchFromGitLab sources.reformDebianPackages;
in
map (lib.removePrefix "${reformDebianPackages}/") (
  lib.filesystem.listFilesRecursive "${reformDebianPackages}/linux/patches${lib.versions.majorMinor sources.modDirVersion}"
)

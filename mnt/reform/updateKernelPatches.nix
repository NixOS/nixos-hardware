{
  lib,
  fetchFromGitLab,
}:

let
  sources = lib.importJSON ./sources.json;
  reformDebianPackages = fetchFromGitLab sources.reformDebianPackages;
in
map (lib.removePrefix "${reformDebianPackages}/") (
  lib.filesystem.listFilesRecursive "${reformDebianPackages}/linux/patches${lib.versions.majorMinor sources.modDirVersion}"
)

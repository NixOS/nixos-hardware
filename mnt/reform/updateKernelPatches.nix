{
  runCommand,
  lib,
  fetchFromGitLab,
}:

let
  sources = lib.importJSON ./sources.json;
  reformDebianPackages = fetchFromGitLab sources.reformDebianPackages;
in
runCommand "mnt-reform-kernel-patches" { } ''
  shopt -s globstar
  cd ${reformDebianPackages}
  echo -e "[\n$(printf '  "%s"\n' linux/patches${lib.versions.majorMinor sources.modDirVersion}/**/*.patch)\n]"> $out
''

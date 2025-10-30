{
  lib,
  fn ? p: import p,
  args ? { },
}:
let
  pkgs = builtins.mapAttrs (_name: p: fn p args) {
    microsoft-surface = ./microsoft/surface/pkgs;
  };
in
lib.foldAttrs (item: acc: item // acc) { } (
  lib.flatten (
    lib.attrValues (
      lib.mapAttrs (
        toplevelName: jobs:
        lib.listToAttrs (lib.mapAttrsToList (name: lib.nameValuePair "${toplevelName}/${name}") jobs)
      ) pkgs
    )
  )
)

# Cross-build aarch64 NixOS on x86_64 without remote builders.
{
  lib,
  buildSystem ? (if builtins ? currentSystem then builtins.currentSystem else null),
  ...
}:

let
  enableCross = buildSystem != null && buildSystem != "aarch64-linux";
in
{
  nixpkgs.buildPlatform = lib.mkIf enableCross {
    system = buildSystem;
  };
}

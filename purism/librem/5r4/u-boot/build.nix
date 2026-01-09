let
  privateInputs =
    (import ../../../../../tests/flake-compat.nix {
      src = ../../../../../tests;
    }).defaultNix;
  pkgs = privateInputs.nixos-unstable-small.legacyPackages.aarch64-linux;
in
pkgs.callPackage ./. { }

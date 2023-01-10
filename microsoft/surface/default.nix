{ lib, ... }:

let
  inherit (lib) warn;

in {
  imports = [
    ( warn
      "Please do not import microsoft/surface/ (default.nix) directly; use microsoft/surface/old or see microsoft/surface/old/README.md for more details."
      ./old )
  ];
}

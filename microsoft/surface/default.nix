{ lib, ... }:

let
  inherit (lib) warn;

in {
  imports = [
    ( warn
      "Please don't import microsoft/surface/ (default.nix) any longer; use microsoft/surface/old or see microsoft/surface/old/README.md for more details."
      ./old )
  ];
}

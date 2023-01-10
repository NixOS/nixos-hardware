{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ./old
  ];
}

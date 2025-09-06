# This file is necessary so nix-env -qa does not break,
# when nixos-hardware is used as a channel
{ pkgs }:
import ./toplevel.nix {
  fn = p: pkgs.callPackages "${builtins.toString p}/all.nix";
  inherit (pkgs) lib;
}

{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [ (import ./../pkgs) ];
}

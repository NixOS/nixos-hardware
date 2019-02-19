{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../common/pc/laptop/cpu-throttling-bug.nix
    ../.
  ];
}

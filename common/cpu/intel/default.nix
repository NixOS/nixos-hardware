{ config, lib, pkgs, ... }:

{
  imports = [
    ./cpu-only.nix
    ../../gpu/intel.nix
  ];
}

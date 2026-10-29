{ lib, pkgs, ... }:
{
  imports = [
    ../.
    # Use the more efficient pstate driver:
    ../../../../../common/cpu/amd/pstate.nix
  ];
}

{ config, lib, ...}:
with lib;
{
  imports = [
    ./..
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
  ];
}

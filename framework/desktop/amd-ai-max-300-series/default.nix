{ config, lib, ... }:
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/ssd
    ../../framework-tool.nix
  ];
}

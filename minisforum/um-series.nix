# Common configuration for Minisforum UM series mini PCs
# (UM690, UM690S, UM790 Pro)
{ ... }:

{
  imports = [
    ../common/cpu/amd
    ../common/cpu/amd/pstate.nix
    ../common/gpu/amd
    ../common/pc/ssd
  ];
}

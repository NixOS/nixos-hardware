# This will enable only the integrated AMD GPU, while disabling the dedicated Nvidia GPU
{ ... }:
{
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/gpu/amd
    ../../../../common/gpu/nvidia/disable.nix
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];
}

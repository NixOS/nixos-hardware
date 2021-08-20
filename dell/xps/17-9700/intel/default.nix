{ lib, pkgs, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../../../../common/gpu/nvidia-disable.nix
    ../common.nix
  ];
}

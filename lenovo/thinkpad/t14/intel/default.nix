{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/intel
    ../../../../common/gpu/intel
  ];
}

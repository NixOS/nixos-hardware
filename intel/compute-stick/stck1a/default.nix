{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/bay-trail
    ./sd-slot-fix.nix
  ];
}

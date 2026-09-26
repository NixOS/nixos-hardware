{ config, lib, ... }:
with lib;
{
  imports = [
    ./..
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../ppt.nix
  ];

  hardware.bluetooth.enable = lib.mkDefault true;
}

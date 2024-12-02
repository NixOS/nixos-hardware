{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/ssd/default.nix
  ];

  services.throttled.enable = lib.mkDefault true;
}

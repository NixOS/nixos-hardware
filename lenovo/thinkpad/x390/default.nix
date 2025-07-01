{ lib, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/ssd/default.nix
  ];

  services.throttled.enable = lib.mkDefault true;
}

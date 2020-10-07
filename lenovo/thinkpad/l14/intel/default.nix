{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/intel
  ];

  services.throttled.enable = lib.mkDefault true;
}

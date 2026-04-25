{ config, lib, ... }:

{
  imports = [ ../. ];

  services.tlp.enable = lib.mkDefault (!config.services.power-profiles-daemon.enable);
}

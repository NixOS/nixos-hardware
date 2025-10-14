{ lib, config, ... }: {
  imports = [ ../. ];

  config.services.power-profiles-daemon.enable = lib.mkDefault (!config.services.tlp.enable);
}

{ config, lib, ... }:

{
  imports = [ ../. ];

  # Gnome 40 introduced a new way of managing power, without tlp.
  # However, these 2 services clash when enabled simultaneously.
  # https://github.com/NixOS/nixos-hardware/issues/260
  services.tlp.enable = lib.mkDefault
    (if config.services.power-profiles-daemon.enable == true then
      false
    else
      true);
}

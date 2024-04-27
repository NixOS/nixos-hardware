{ config, lib, ... }:
with lib;
{
  config = {
    # Wifi can't connect if rand mac address is used
    networking.networkmanager.settings.device = {
      match-device = "driver:iwlwifi";
      wifi.scan-rand-mac-address = "no";
    };
  };
}

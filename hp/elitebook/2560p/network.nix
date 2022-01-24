{ config, pkgs, lib, ... }:
with lib;
{
  config = {
    # Wifi can't connect if rand mac address is used
    networking.networkmanager.extraConfig = concatStringsSep "\n" [
      "[device]"
      "match-device=driver:iwlwifi"
      "wifi.scan-rand-mac-address=no"
    ];
  };
}

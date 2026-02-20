# MediaTek MT7925 - iwd backend configuration
#
# Use iwd instead of wpa_supplicant for MT7925. iwd provides better
# stability and faster roaming for WiFi 7 chips.
#
# Import this alongside default.nix:
#   imports = [
#     ../common/wifi/mediatek/mt7925
#     ../common/wifi/mediatek/mt7925/iwd.nix
#   ];
{ lib, ... }:

{
  # Required for iwd to work with MT7925 - includes non-redistributable firmware
  hardware.enableAllFirmware = lib.mkDefault true;

  # Use iwd backend instead of wpa_supplicant
  networking.networkmanager.wifi.backend = lib.mkDefault "iwd";

  # iwd configuration for MT7925 stability
  networking.wireless.iwd.settings = {
    General = {
      # Consistent MAC per network (fixes WPA3 handshake issues)
      AddressRandomization = "network";

      # Let NetworkManager handle IP configuration, not iwd
      # (prevents conflicts between iwd and NetworkManager)
      EnableNetworkConfiguration = false;
    };
    Settings = {
      AutoConnect = true;
    };
  };
}

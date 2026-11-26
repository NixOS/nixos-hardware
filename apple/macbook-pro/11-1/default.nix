{ lib, config, ... }:
{
  imports = [
    ../.
    ../../../common/pc/ssd
    ../../../common/cpu/intel/haswell
    ../../../common/broadcom-wifi.nix
  ];
  # ##############################################################################
  # ATTENTION / IMPORTANT NOTE:
  #
  # Note: Enabling WiFi and Bluetooth functionality on this hardware requires
  # the proprietary Broadcom driver. Due to outstanding security issues, you
  # need to explicitly opt-in by setting:
  #
  # hardware.broadcom.wifi.enableLegacyDriverWithKnownVulnerabilities = true;
  # ##############################################################################
  config = {
    hardware.enableRedistributableFirmware = lib.mkDefault true; # broadcom-wl
  };
}

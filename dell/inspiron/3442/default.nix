{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/haswell
    ../../../common/pc/laptop
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
    services = {
      fwupd.enable = lib.mkDefault true;
      thermald.enable = lib.mkDefault true;
    };
  };
}

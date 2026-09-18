{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
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
    boot.kernelModules = [
      "kvm-intel"
    ];

    services = {
      fwupd.enable = lib.mkDefault true;
      thermald.enable = lib.mkDefault true;
    };
  };
}

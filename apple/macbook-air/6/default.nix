{ config, lib, ... }:

{
  imports = [
    ../.
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
    boot = {
      # Divides power consumption by two.
      kernelParams = [ "acpi_osi=" ];

      blacklistedKernelModules = [ "bcma" ];
    };

    services.xserver.deviceSection = lib.mkDefault ''
      Option "TearFree" "true"
    '';
  };
}

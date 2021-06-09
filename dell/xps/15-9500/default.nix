{ lib, ... }:
let
  thermald-conf = ./thermald-conf.xml;
in
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Boot loader
  boot.kernelParams = lib.mkDefault [ "acpi_rev_override" ];

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;

  # Thermald doesn't have a default config for the 9500 yet, the one in this repo
  # was generated with dptfxtract-static (https://github.com/intel/dptfxtract)
  services.thermald.configFile = lib.mkDefault thermald-conf;
  
  # WiFi speed is slow and crashes by default
  # disable_11ax - doesn't actually disable AX but will fix the speed and crashes
  # power_save - works well on this card
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=1 disable_11ax=1
  '';
}

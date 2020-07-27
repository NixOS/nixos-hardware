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

  # Set the tlp config to powersave explictly. TLP is enabled in common/pc/laptop.
  services.tlp.extraConfig = lib.mkDefault "CPU_SCALING_GOVERNOR_ON_AC=powersave\nCPU_SCALING_GOVERNOR_ON_BAT=powersave";
}

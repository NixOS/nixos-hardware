# Implementation of support for general System76 hardware.
#
# https://system76.com/

{ config, ... }:
let
  # Try loading all system76 modules.  The ones not relevant to specific
  # hardware won't be loaded.
  packages = with config.boot.kernelPackages; [ system76 system76-acpi system76-io ];
in
{
  imports = [ ../common/pc ];

  # This seems to be required for system76-driver.
  boot.kernelParams = [ "ec_sys.write_support=1" ];

  boot.extraModulePackages = packages;

  # Explicitly attempt to load all available system76 modules.  Some do
  # (system76-acpi), some don't (system76-io).
  boot.kernelModules = map (drv: drv.moduleName) packages;
}

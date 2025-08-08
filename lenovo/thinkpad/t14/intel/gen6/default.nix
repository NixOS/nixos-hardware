{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/lunar-lake
  ];

  # T14 Gen 6 uses Intel Core Ultra processors (Lunar Lake architecture)
  # with integrated Intel Arc graphics
  # The lunar-lake module already includes appropriate GPU support

  # Ensure modern kernel for full Lunar Lake support
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.8") pkgs.linuxPackages_latest;

  # TODO: Looking for feedback on these kernel parameters for T14 Gen 6
  # Force use of the thinkpad_acpi driver for backlight control
  # This allows the backlight save/load systemd service to work
  boot.kernelParams = [
    "acpi_backlight=native"
    # TODO: Looking for feedback - touchpad fix needed for proper click registration on some T14 models
    "psmouse.synaptics_intertouch=0"
  ];

  # TODO: Looking for feedback - modern Intel CPUs don't typically need throttled service
  # which can interfere with newer power management on Lunar Lake
  services.throttled.enable = lib.mkDefault false;
}
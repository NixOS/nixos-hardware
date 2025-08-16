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

  # Enable fingerprint reader support
  # NOTE: PAM configuration should be done in host config to avoid login issues
  # See: https://github.com/NixOS/nixpkgs/issues/171136
  services.fprintd.enable = lib.mkDefault true;

  # For complete fingerprint authentication in GNOME, add the following to your host config:
  #
  # security.pam.services = {
  #   # Enable fingerprint authentication for sudo
  #   sudo.fprintAuth = lib.mkDefault true;
  #
  #   # Enable fingerprint authentication for su
  #   su.fprintAuth = lib.mkDefault true;
  #
  #   # Enable fingerprint authentication for screen unlock
  #   xscreensaver.fprintAuth = lib.mkDefault true;
  #
  #   # WARNING: login.fprintAuth may break GDM password authentication
  #   # Only enable if you understand the risks:
  #   # login.fprintAuth = lib.mkDefault true;
  # };
  #
  # After configuration:
  # 1. Rebuild your system
  # 2. Enroll fingerprint: sudo fprintd-enroll $USER
  # 3. Test sudo and screen unlock with fingerprint
}

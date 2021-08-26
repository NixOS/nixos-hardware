{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    ../../../common/pc/laptop/acpi_call.nix
  ];

  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"
  ];
}

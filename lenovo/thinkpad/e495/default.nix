{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/amd
  ];

  # see https://github.com/NixOS/nixpkgs/issues/69289
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.2") pkgs.linuxPackages_latest;

  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"
  ];
}

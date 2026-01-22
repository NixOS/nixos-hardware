{ lib, pkgs, ... }:

{
  imports = [
    ../.
  ];

  # For suspending to RAM to work, set Config -> Power -> Sleep State to "Linux" in EFI.
  # See https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6)#Suspend_issues

  # Fingerprint sensor requires a firmware-update to work.

  # Force use of the thinkpad_acpi driver for backlight control.
  # This allows the backlight save/load systemd service to work.
  boot.kernelParams = [ "acpi_backlight=native" ];

  # see https://github.com/NixOS/nixpkgs/issues/69289
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.2") pkgs.linuxPackages_latest;
}

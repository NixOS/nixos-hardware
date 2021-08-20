
{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../../../common/pc/laptop/acpi_call.nix
  ];

  # For suspending to RAM, set Config -> Power -> Sleep State to "Linux" in EFI.

  # amdgpu.backlight=0 makes the backlight work
  # acpi_backlight=none allows the backlight save/load systemd service to work.
  boot.kernelParams = ["amdgpu.backlight=0" "acpi_backlight=none"];

  # Wifi support
  boot.extraModulePackages = [ config.boot.kernelPackages.rtw89 ];
  hardware.firmware = [ pkgs.rtw89-firmware ];

  # For support of newer AMD GPUs, backlight and internal microphone
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.13") pkgs.linuxPackages_latest;
}
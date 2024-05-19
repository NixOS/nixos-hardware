{ lib, pkgs, config, ... }:
{
  imports = [
    ../.
    ../../../../../common/cpu/amd/pstate.nix
  ];

  # For suspending to RAM, set Config -> Power -> Sleep State to "Linux" in EFI.

  # amdgpu.backlight=0 makes the backlight work
  # acpi_backlight=none allows the backlight save/load systemd service to work on older kernel versions
  boot.kernelParams = [ "amdgpu.backlight=0" ] ++ lib.optional (lib.versionOlder config.boot.kernelPackages.kernel.version "6.1.6") "acpi_backlight=none";

  # For mainline support of rtw89 wireless networking
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;
}

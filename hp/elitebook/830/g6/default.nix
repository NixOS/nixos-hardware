{ pkgs, lib, ... }:
{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../../../../common/pc/laptop/ssd
  ];

  # Needed for wifi
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = lib.mkDefault true;

  # Enables ACPI platform profiles
  boot = lib.mkIf (lib.versionAtLeast pkgs.linux.version "6.1") {
    kernelModules = [ "hp-wmi" ];
  };

  # reduces warnings/errors in boot log, seems to eliminate the ocassional boot hangs described in readme
  hardware.enableAllFirmware = lib.mkDefault true;
}

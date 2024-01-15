{ pkgs, ... }:
{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../../../../common/pc/laptop/acpi_call.nix
    ../../../../common/pc/laptop/ssd
  ];

  # is there any redistributable firmware for this device?
  hardware.enableRedistributableFirmware = true;

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = lib.mkDefault true;
}
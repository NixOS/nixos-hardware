{ lib, ... }:
{
  imports = [
    ../.
    ../../../../common/pc/laptop/acpi_call.nix
    ../../../../common/pc/laptop/ssd
  ];

  services.throttled.enable = lib.mkDefault true;
}

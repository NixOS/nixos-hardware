{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/hdd # TODO: reverse compat
    ../tp-smapi.nix
  ];
  # doesn't support acpi_call
  boot.acpi_call.enable = false;
}

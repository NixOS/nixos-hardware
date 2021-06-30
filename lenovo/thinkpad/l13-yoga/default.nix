{ nixos, lib, pkgs, config, stdenv, ... }:
{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
  ];

  services.throttled.enable = lib.mkDefault true;

  # automatic screen orientation
  hardware.sensor.iio.enable = true;

  services.xserver.wacom.enable = lib.mkDefault config.services.xserver.enable;
}

{ nixos, lib, pkgs, config, stdenv, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;
}

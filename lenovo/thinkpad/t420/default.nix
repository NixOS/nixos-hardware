{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/intel/sandy-bridge
    ../../../common/pc/laptop/acpi_call.nix
  ];
}

{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/intel
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/ssd
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;
}

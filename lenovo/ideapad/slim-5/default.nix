{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd
  ];
}

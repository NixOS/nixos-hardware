{ lib, ... }:

{
  imports = [
    ../../.
    ../../../../common/cpu/intel
  ];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;
}

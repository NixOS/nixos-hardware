{ lib, ... }:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # Cooling management
  services.thermald.enable = lib.mkDefault true;
}

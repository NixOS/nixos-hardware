{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
  ];

  services.thermald.enable = lib.mkDefault true;
}

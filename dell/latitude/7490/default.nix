{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  services.thermald.enable = lib.mkDefault true;
}

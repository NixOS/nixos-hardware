{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/coffee-lake
  ];

  services.thermald.enable = lib.mkDefault true;
}

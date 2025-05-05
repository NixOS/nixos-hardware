{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;
}

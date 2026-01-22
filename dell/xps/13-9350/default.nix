{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/lunar-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # The touchpad uses I²C, so PS/2 is unnecessary
  boot.blacklistedKernelModules = [ "psmouse" ];

  # Recommended in NixOS/nixos-hardware#127
  services.thermald.enable = lib.mkDefault true;
}

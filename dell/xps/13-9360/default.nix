{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
  ];

  boot.blacklistedKernelModules = [ "psmouse" ]; # touchpad goes over i2c

  # TODO: decide on boot loader policy
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkDefault true;
    systemd-boot.enable = lib.mkDefault true;
  };

  # This will save you money and possibly your life!
  services.thermald.enable = true;
}

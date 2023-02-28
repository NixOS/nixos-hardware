{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Set to true for just the first run, then disable it.
  # boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Load GPU drivers.
  # hardware.bumblebee.enable = lib.mkDefault true;

  # High DPI for X users. 175 "looks reasonable" but I didn't do the actual DPI
  # calculation.
  # services.xserver.dpi = lib.mkDefault 175;

  # Earlier font-size setup
  console.earlySetup = true;

  # Prevent small EFI partiion from filling up
  boot.loader.grub.configurationLimit = 10;

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;
}

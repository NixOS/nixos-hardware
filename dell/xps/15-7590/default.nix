{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Force S3 sleep mode. See README.wiki for details.
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Earlier font-size setup
  console.earlySetup = true;

  # Prevent small EFI partiion from filling up
  boot.loader.grub.configurationLimit = 10;

  # Enable firmware updates via `fwupdmgr`.
  services.fwupd.enable = lib.mkDefault true;

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;
}

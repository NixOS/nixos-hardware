{ lib, ... }:

let
  inherit (lib) mkDefault;

in {
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../sleep-resume/i2c-designware
  ];

  # Force S3 sleep mode. See README.wiki for details.
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Touchpad goes over i2c, and the psmouse module interferes with it
  boot.blacklistedKernelModules = [ "psmouse" ];

  # Includes the Wi-Fi and Bluetooth firmware for the QCA6390.
  hardware.enableRedistributableFirmware = mkDefault true;

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = mkDefault true;

  # This will save you money and possibly your life!
  services.thermald.enable = mkDefault true;

  # Reloads i2c-designware module after suspend
  services.sleep-resume.i2c-designware.enable = mkDefault true;
}

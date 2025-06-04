{ lib, pkgs, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Includes the Wi-Fi and Bluetooth firmware for the QCA6390.
  hardware.enableRedistributableFirmware = true;

  # Requires at least 5.12 for working wi-fi and bluetooth.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.12") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  # Touchpad goes over i2c.
  # Without this we get errors in dmesg on boot and hangs when shutting down.
  boot.blacklistedKernelModules = [ "psmouse" ];

  # enable finger print sensor.
  # this has to be configured with `sudo fprintd-enroll <username>`.
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = true;
}

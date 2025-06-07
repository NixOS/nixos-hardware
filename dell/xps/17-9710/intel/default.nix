{ lib, pkgs, ... }:
{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # Includes the Wi-Fi and Bluetooth firmware
  hardware.enableRedistributableFirmware = true;

  # Requires at least 5.12 for working sound
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.12") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

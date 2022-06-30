
{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
  ];
  # Wifi support
  hardware.firmware = [ pkgs.rtw89-firmware ];

  # For mainline support of rtw89 wireless networking
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;
}

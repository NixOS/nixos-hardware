{ lib, pkgs, ... }:
{
  imports = [
    ../.
  ];

  # For mainline support of rtw89 wireless networking
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;

  # Enable energy savings during sleep
  boot.kernelParams = [ "mem_sleep_default=deep" ];
}

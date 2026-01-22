{ lib, pkgs, ... }:
{
  imports = [
    ../.
    ../../../../common/pc/ssd
  ];

  # This solves lagging noticeable on high-resolution screens.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.15") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

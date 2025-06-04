{ lib, pkgs, ... }:
{
  # This can be removed when the default kernel is at least version 5.11 due to sof module
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.11") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

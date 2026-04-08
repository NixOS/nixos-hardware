{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/intel.nix
  ];

  # Everything is updateable through fwupd
  services.fwupd.enable = true;

  # Absolute minimum
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.17") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/amd.nix
  ];

  # 6.14 is the minimum recommended kernel, 6.15 has many useful changes, too
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.15") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  # Everything is updateable through fwupd
  services.fwupd.enable = true;
}

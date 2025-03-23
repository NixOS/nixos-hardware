{ lib, pkgs, ... }: {
  imports = [
    ../.
    ../../../../../common/pc/laptop/ssd
  ];

  # At least kernel 5.19 is required for the system to work properly.
  boot.kernelPackages = lib.mkIf
    (lib.versionOlder pkgs.linux.version "5.19")
    (lib.mkDefault pkgs.linuxPackages_latest);
}

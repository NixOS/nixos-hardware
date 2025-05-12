{ lib, pkgs, ... }:
{
  imports = [
    ../../../../common/cpu/intel/lunar-lake
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # touchpad, wifi, and bluetooth do not work before 6.12
  config.boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.12") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

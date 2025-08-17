{ lib, pkgs, ... }:
{
  imports = [
    ../../../../common/cpu/intel/lunar-lake
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  # device will not boot in kernel versions older than 6.15
  config.boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.15") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

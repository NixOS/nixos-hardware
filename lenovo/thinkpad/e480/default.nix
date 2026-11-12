{ lib, pkgs, ... }:
{
  imports = [
    ../.
    ../../../common/cpu/intel/kaby-lake
    ../../../common/gpu/intel
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.6") pkgs.linuxPackages_latest;
}

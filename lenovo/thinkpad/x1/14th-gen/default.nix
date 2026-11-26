{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/intel/panther-lake
    ../../../../common/pc/ssd
  ];

  # SoundWire SDCA class driver and their SOF function topologies arrived in Linux 6.19.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.19") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

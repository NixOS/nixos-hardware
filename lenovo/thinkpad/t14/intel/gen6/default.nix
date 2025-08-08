{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/lunar-lake
  ];

  # T14 Gen 6 uses Intel Core Ultra processors (Lunar Lake architecture)
  # with integrated Intel Arc graphics
  # The lunar-lake module already includes appropriate GPU support

  # Ensure modern kernel for full Lunar Lake support
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.8") pkgs.linuxPackages_latest;
}
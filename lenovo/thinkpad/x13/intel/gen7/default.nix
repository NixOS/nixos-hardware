{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../../../../common/pc/ssd
    ../../../../../common/cpu/intel/panther-lake
  ];

  # Absolute minimum
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.17") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

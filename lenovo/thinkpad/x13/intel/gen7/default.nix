{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../common.nix
    ../../../../../common/cpu/intel/panther-lake
  ];

  # Starting with Linux 6.17, Intel Panther Lake support is included in the
  # mainline kernel.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.17") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

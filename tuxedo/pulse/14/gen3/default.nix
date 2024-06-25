{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ../../../../common/cpu/amd
    ../../../../common/cpu/amd/pstate.nix
    ../../../../common/cpu/amd/raphael/igpu.nix
    ../../../../common/pc/laptop
    ../../../../common/pc/laptop/ssd
  ];

  # Fixing a power-issue with older kernels.
  # When powered off, the battery does not turn off completely.
  # Kernel 6.8.12 fixes this,
  # the exact version is still unknown which fixed this.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.8.12") (
    if (config.boot.zfs.enabled)
    then pkgs.zfs.latestCompatibleLinuxPackages
    else pkgs.linuxPackages_latest
  );
}

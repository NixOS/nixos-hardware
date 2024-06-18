{ lib, pkgs, ... }:

{
  imports = [
    ../common
    ../common/intel.nix
  ];

  # Need at least 6.9 to make suspend properly
  # Specifically this patch: https://github.com/torvalds/linux/commit/073237281a508ac80ec025872ad7de50cfb5a28a
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.9") (lib.mkDefault pkgs.linuxPackages_latest);
}

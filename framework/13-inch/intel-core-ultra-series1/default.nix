{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/intel.nix
  ];

  # Everything is updateable through fwupd
  services.fwupd.enable = true;

  # Need at least 6.9 to make suspend properly
  # Specifically this patch: https://github.com/torvalds/linux/commit/073237281a508ac80ec025872ad7de50cfb5a28a
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.9") (
    lib.mkDefault pkgs.linuxPackages_latest
  );

  hardware.framework.laptop13.audioEnhancement.rawDeviceName =
    lib.mkDefault "alsa_output.pci-0000_00_1f.3.analog-stereo";
}

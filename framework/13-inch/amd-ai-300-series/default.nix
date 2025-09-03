{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../common
    ../common/amd.nix
  ];

  config = {
    # Everything is updateable through fwupd
    services.fwupd.enable = true;

    hardware.framework.laptop13.audioEnhancement.rawDeviceName =
      lib.mkDefault "alsa_output.pci-0000_c1_00.6.analog-stereo";

    # suspend works with 6.15
    boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.15") (
      lib.mkDefault pkgs.linuxPackages_latest
    );
  };
}

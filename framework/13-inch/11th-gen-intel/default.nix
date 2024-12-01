{ lib, pkgs, ...}: {
  imports = [
    ../common
    ../common/intel.nix
  ];

  # Requires at least 5.16 for working wi-fi and bluetooth.
  # https://community.frame.work/t/using-the-ax210-with-linux-on-the-framework-laptop/1844/89
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") (lib.mkDefault pkgs.linuxPackages_latest);

  hardware.framework.laptop13.audioEnhancement.rawDeviceName = lib.mkDefault "alsa_output.pci-0000_00_1f.3.analog-stereo";
}

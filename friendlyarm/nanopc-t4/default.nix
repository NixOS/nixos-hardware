{ lib, pkgs, ... }:

{
  boot.loader = {
    grub.enable = lib.mkDefault false;
    # Enables the generation of /boot/extlinux/extlinux.conf.
    generic-extlinux-compatible.enable = lib.mkDefault true;
  };

  # UART debug console bitrates.
  boot.kernelParams = [ "console=ttyS2,1500000" ];

  # Enable additional firmware (such as Wi-Fi drivers).
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # Fix for not detecting the M.2 NVMe SSD. Will cause recompilation.
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.10") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
  boot.kernelPatches = lib.mkDefault [
    {
      name = "pcie-rockchip-config.patch";
      patch = null;
      extraConfig = ''
        PHY_ROCKCHIP_PCIE y
        PCIE_ROCKCHIP_HOST y
      '';
    }
  ];
}

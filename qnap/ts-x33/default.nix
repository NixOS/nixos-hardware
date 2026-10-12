{ lib, pkgs, ... }:

{
  boot = {
    # TS-233 device-tree support requires Linux 6.19 or newer.
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    initrd = {
      # Allow booting from the eMMC or USB in addition to SATA.
      availableKernelModules = [
        "dwc3"
        "ehci_platform"
        "mmc_block"
        "ohci_platform"
        "phy_rockchip_inno_usb2"
        "sdhci_of_dwcmshc"
        "uas"
        "usb_storage"
        "xhci_plat_hcd"
      ];

      # Load the Rockchip SATA PHY and controller before the initrd searches
      # for filesystems.
      kernelModules = [
        "phy_rockchip_naneng_combphy"
        "ahci_dwc"
      ];
    };

    # QNAP configures this serial console for 115200 rather than Rockchip's
    # commonly used 1500000 baud.
    kernelParams = [ "console=ttyS2,115200n8" ];

    # Let the external battery-backed RTC selected by the device tree become
    # rtc0 instead of the RK809 PMIC's RTC.
    blacklistedKernelModules = [ "rtc_rk808" ];

    # Mainline U-Boot loads NixOS generations from extlinux.conf.
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
    };
  };

  hardware.deviceTree.enable = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}

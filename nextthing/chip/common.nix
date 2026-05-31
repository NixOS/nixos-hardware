{ pkgs, lib, ... }:

{
  nixpkgs.hostPlatform.system = "armv7l-linux";

  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.generic-extlinux-compatible.enable = lib.mkDefault true;

  hardware.deviceTree.name = lib.mkDefault "sun5i-r8-chip.dtb";

  # PMIC driver is required for the USB PHY to function. Critical for USB boot
  # platform 1c14000.usb: deferred probe pending: platform: supplier 1c13400.phy not ready
  boot.initrd.availableKernelModules = [
    # CONFIG_AXP20X_ADC=m
    "axp20x_adc"
    "axp20x_usb_power"
    "axp20x_battery"
    "axp20x_ac_power"
  ];

  # Workaround random freezes
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Using overlays here so we can modularly override it in nand.nix and pocketchip/default.nix
  nixpkgs.overlays = lib.mkBefore [
    (final: _prev: {
      ubootCHIP = final.buildUBoot {
        defconfig = "CHIP_defconfig";
        extraMeta.platforms = [ "armv7l-linux" ];
        filesToInstall = [
          "u-boot-sunxi-with-spl.bin"
        ];
      };
    })
  ];
  system.build.uboot = lib.mkDefault pkgs.ubootCHIP;

  # Mali 400 GPU
  hardware.graphics.enable = lib.mkDefault true;
}

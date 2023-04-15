{ lib, pkgs, ... }:

{
  imports = [
    ../4/audio.nix
    ../4/backlight.nix
    ../4/cpu-revision.nix
    ../4/dwc2.nix
    ../4/i2c.nix
    ../4/modesetting.nix
    ../4/poe-hat.nix
    ../4/poe-plus-hat.nix
    ../4/tc358743.nix
    ../4/touch-ft5406.nix
    ../4/pwm0.nix
    ../4/pkgs-overlays.nix
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
      "vc4"
      "pcie_brcmstb"      # required for the pcie bus to work
      "reset-raspberrypi" # required for vl805 firmware to load
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.deviceTree.filter = "bcm2837-rpi-3-b-plus.dtb";
}

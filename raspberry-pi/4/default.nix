{ lib, pkgs, ...}:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  nix.buildCores = 4;

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;
}
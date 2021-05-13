{ lib, pkgs, ...}:

{
  imports = [
    ./modesetting.nix
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };


  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;
}

{ lib, pkgs, ...}:

{
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" ];

    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
        firmwareConfig = ''
          dtparam=audio=on 
          gpu_mem=192
        '';
      };
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  nix.buildCores = 4;

  # Required for the Wireless firmware
  hardware.enableRedistributableFirmware = true;

}
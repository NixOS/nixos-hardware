{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./petitboot
  ];

  # Enable petitboot support.
  boot.loader.petitboot.enable = lib.mkForce true;

  # `nixos-rebuild` fails unless grub is explicitly disabled.
  boot.loader.grub.enable = lib.mkForce false;

  boot.initrd.availableKernelModules = [
    "nvme"
  ];

  # Petitboot uses this port and baud rate on the board's serial port. It's
  # probably good to keep the options same for the running kernel for serial
  # console access to work well.
  boot.kernelParams = [ "console=ttyS2,1500000" ];
  hardware.deviceTree.name = "rockchip/rk3568-odroid-m1.dtb";
  # FIXME: The serial terminal does seem to throw random errors still, but that
  #        doesn't appear to crash anything. May need adjusted if you're
  #        actually using the GPIO.
}

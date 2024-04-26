{ lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ./overlay.nix)
  ];

  boot = {
    kernelPackages = lib.mkDefault (pkgs.linuxPackagesFor pkgs.linux_rpi5);
    initrd.availableKernelModules = [
      "usbhid"
      "usb_storage"
    ];
  };
}

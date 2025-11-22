{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./audio.nix
    ./backlight.nix
    ./bluetooth.nix
    ./cpu-revision.nix
    ./digi-amp-plus.nix
    ./dwc2.nix
    ./gpio.nix
    ./i2c.nix
    ./leds.nix
    ./modesetting.nix
    ./pkgs-overlays.nix
    ./poe-hat.nix
    ./poe-plus-hat.nix
    ./pwm0.nix
    ./tc358743.nix
    ./touch-ft5406.nix
    ./tv-hat.nix
    ./xhci.nix
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "usbhid"
      "usb-storage"
      "vc4"
      "pcie-brcmstb" # required for the pcie bus to work
      "reset-raspberrypi" # required for vl805 firmware to load
    ]
    ++ lib.optional config.boot.initrd.network.enable "genet";

    # Allow building kernel
    initrd.systemd.tpm2.enable = false;

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.deviceTree.filter = lib.mkDefault "bcm2711-rpi-*.dtb";

  assertions = [
    {
      assertion = (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1");
      message = "This version of raspberry pi 4 dts overlays requires a newer kernel version (>=6.1). Please upgrade nixpkgs for this system.";
    }
  ];

  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];
}

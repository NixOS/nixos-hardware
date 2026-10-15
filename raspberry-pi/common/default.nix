{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./config-txt.nix
    ./config-txt-defaults.nix
    ./dwc2.nix
    ./firmware.nix
    ./gpio.nix
    ./i2c.nix
    ./modesetting.nix
  ];

  boot.initrd.availableKernelModules = [
    "usb-storage"
    "usbhid"
    "vc4"
  ];
}

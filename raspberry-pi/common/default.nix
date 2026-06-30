{
  imports = [
    ./config-txt.nix
    ./config-txt-defaults.nix
  ];

  boot.initrd.availableKernelModules = [
    "usb-storage"
    "usbhid"
    "vc4"
  ];
}

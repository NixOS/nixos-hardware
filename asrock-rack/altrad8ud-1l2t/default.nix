{
  imports = [ ../../common/networking/intel/x550 ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "usb_storage"
    "nvme"
  ];
  nixpkgs.hostPlatform = "aarch64-linux";
}

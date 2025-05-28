{
  imports = [
    ../../../../common/cpu/intel/meteor-lake
    ../../../../common/pc/laptop
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "sd_mod"
    "thunderbolt"
    "usb_storage"
    "vmd"
    "xhci_pci"
  ];
}

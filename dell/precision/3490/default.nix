{
  imports = [
    ../../../common/cpu/intel/meteor-lake
    ../../../common/gpu/nvidia/ada-lovelace
    ../../../common/pc/laptop
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "sd_mod"
    "thunderbolt"
    "usb_storage"
    "vmd"
    "xhci_pci"
  ];

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}

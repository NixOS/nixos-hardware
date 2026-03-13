{
  imports = [
    ../.
    ../../../common/cpu/intel/haswell
  ];
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.kernelModules = [ "kvm-intel" ];
  nixpkgs.hostPlatform = "x86_64-linux";

  # For intel Wireless 7260 non free firmware iwlwifi-7260017
  hardware.enableRedistributableFirmware = true;
}

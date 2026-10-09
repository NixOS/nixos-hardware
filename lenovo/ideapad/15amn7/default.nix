{ lib, ... }:

{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "usb_storage"
        "xhci_pci"
      ];
    };
    kernelModules = [ "kvm-amd" ];
  };
  # For the rtw88_8822ce firmware (Wi-Fi).
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}

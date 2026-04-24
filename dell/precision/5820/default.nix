{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc
    ../../../common/pc/ssd
    ../../../common/gpu/nvidia
  ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "vmd"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];

  hardware = {
    nvidia = {
      nvidiaSettings = lib.mkDefault true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.production;
      open = lib.mkDefault false;
    };
  };

  services.thermald.enable = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}

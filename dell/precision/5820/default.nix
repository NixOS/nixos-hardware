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
  ];

  hardware = {
    nvidia = {
      nvidiaSettings = lib.mkDefault true;
      package = lib.mkDefault config.boot.kernelPackages.nvidiaPackages.legacy_580;
      open = lib.mkDefault false;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}

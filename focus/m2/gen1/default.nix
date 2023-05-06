{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/pc/laptop
    ../../../common/pc/laptop/acpi_call.nix
    ../../../common/pc/laptop/ssd
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  hardware.nvidia.modesetting.enable = lib.mkDefault true;
  hardware.opengl = {
    enable = lib.mkDefault true;
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };

  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}

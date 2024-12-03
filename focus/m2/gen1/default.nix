{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
    ../../../common/gpu/nvidia/turing
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.kernelParams = [
    "tpm_tis.interrupts=0" # Upstream bug: https://bugzilla.kernel.org/show_bug.cgi?id=204121
    # without this, kacpid worker thread consumes 100% cpu on kernels 5.15.111 and up
  ];
  boot.blacklistedKernelModules = [ "i2c_nvidia_gpu" ];

  hardware.nvidia.modesetting.enable = lib.mkDefault true;
  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = lib.mkDefault true;
  };

  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:1:0:0";
  };
}

{lib, ...}: {
  imports = [
    ../.
    ../../../../../common/cpu/intel/raptor-lake
    ../../../../../common/gpu/intel/raptor-lake
    ../../../../../common/gpu/nvidia/ampere
    ../../../../../common/gpu/nvidia/prime.nix
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "sd_mod"
    "thunderbolt"
    "usb_storage"
    "usbhid"
    "xhci_pci"
  ];
  boot.kernelModules = ["kvm-intel"];

  # DOCS https://wiki.nixos.org/wiki/NVIDIA#Offload_mode
  hardware.nvidia.prime = {
    intelBusId = lib.mkDefault "PCI:0:2:0";
    nvidiaBusId = lib.mkDefault "PCI:3:0:0";
  };

  # HACK https://github.com/NVIDIA/open-gpu-kernel-modules/issues/472
  hardware.nvidia.open = lib.mkOverride 993 false;
}

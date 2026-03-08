{
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  imports = [
    ../../../../../common/pc/laptop
    ../../../../../common/cpu/intel/coffee-lake
    ../../../../../common/gpu/nvidia/pascal
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  hardware = {
    graphics = {
      enable = mkDefault true;
      enable32Bit = mkDefault true;
    };

    nvidia = {
      # Required to fix screen tearing with PRIME
      modesetting.enable = mkDefault true;
      open = mkDefault false;
      nvidiaSettings = mkDefault true;

      # Enable PRIME for hybrid graphics with sync mode
      # Rendering is completely delegated to the dGPU
      # iGPU only displays the rendered framebuffers copied from the dGPU.
      prime = {
        sync.enable = mkDefault true;
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
  };
}
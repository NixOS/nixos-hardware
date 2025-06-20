{
  lib,
  ...
}:
{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia/prime.nix
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];
  };

  hardware = {
    # Audio
    enableRedistributableFirmware = lib.mkDefault true;

    # Webcam
    ipu6 = {
      enable = lib.mkDefault true;
      platform = lib.mkDefault "ipu6ep";
    };

    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };

    graphics = {
      enable = lib.mkDefault true;
      enable32Bit = lib.mkDefault true;
    };

    intel-gpu-tools.enable = lib.mkDefault true;
    intelgpu = {
      driver = lib.mkDefault "xe";
    };

    nvidia = {
      modesetting.enable = lib.mkDefault true;
      nvidiaSettings = lib.mkDefault true;
      open = lib.mkDefault false;

      powerManagement = {
        enable = lib.mkDefault true;
        finegrained = lib.mkDefault true;
      };

      prime = {
        intelBusId = lib.mkDefault "PCI:00:02:0";
        nvidiaBusId = lib.mkDefault "PCI:01:00:0";
      };
    };
  };

  services = {
    fwupd.enable = lib.mkDefault true; # update firmware
    hardware.bolt.enable = lib.mkDefault true; # use thunderbolt
    pcscd.enable = lib.mkDefault true; # card reader
    thermald.enable = lib.mkDefault true; # fans
  };

}

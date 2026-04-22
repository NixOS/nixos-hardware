{ lib, pkgs, ... }:
{
  imports = [
    ../.
    ../../../../../common/pc/ssd
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "sd_mod"
  ];

  boot.kernelModules = [ "kvm-amd" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.xserver.videoDrivers = [
    "amdgpu"
  ];
  
}

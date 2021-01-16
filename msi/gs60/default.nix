{ config, pkgs, lib, ... }:
{
  imports = [
    ../../common/cpu/intel
    ../../common/pc/laptop
  ];

  boot = {

    # Interferes with Fn- action keys
    kernelParams = [ "video.report_key_events=0" ];

    # Workaround for problematic firmware loading
    extraModprobeConfig = ''
      options ath10k_core skip_otp=y
    '';

    initrd = {
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "rtsx_pci_sdmmc"
        "sd_mod"
        "usb_storage"
        "xhci_pci"
      ];
    };
  };

  # Laptop can't correctly suspend if wlan is active
  powerManagement = {
    powerDownCommands = ''
      ${pkgs.utillinux}/bin/rfkill block wlan
    '';
    resumeCommands = ''
      ${pkgs.utillinux}/bin/rfkill unblock wlan
    '';
  };
}

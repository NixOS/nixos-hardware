{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../../common/gpu/nvidia
  ];
  hardware.enableRedistributableFirmware = lib.mkDefault true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];

  boot = {
    kernelModules = ["kvm-intel"];
    blacklistedKernelModules = ["nouveau"];
  };
  boot.kernelParams = ["i915.modeset=1"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    nvidiaSettings = lib.mkDefault true;
    modesetting.enable = lib.mkDefault true;
    open = lib.mkDefault false;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  hardware.opengl = {
    enable = lib.mkDefault true;
    driSupport = lib.mkDefault true;
    driSupport32Bit = lib.mkDefault true;
  };

  # Override the intel gpu driver setting imported above
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkOverride 990 "nvidia");
  };

  services.thermald.enable = lib.mkDefault true;

  # available cpufreq governors: performance powersave
  # The powersave mode locks the cpu to a 900mhz frequency which is not ideal
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}

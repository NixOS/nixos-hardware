{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../.
    ../../../common/cpu/intel/kaby-lake
    ../../../common/gpu/amd
    ../../../common/hidpi.nix
    ../../../common/pc/laptop/ssd
  ];

  # apple smc (TODO: check spi)
  boot = {
    initrd.kernelModules = ["applespi" "spi_pxa2xx_platform" "intel_lpss_pci" "applesmc" ];
    kernelParams = [ "intel_iommu=on" ];
    kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.0") pkgs.linuxPackages_latest;
  };

  # Wifi, CPU Microcode FW updates
  networking.enableB43Firmware = lib.mkDefault true;
  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    cpu.intel.updateMicrocode = lib.mkDefault true;
  };
}

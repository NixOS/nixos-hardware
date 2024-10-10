{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../.
    ../../../common/cpu/intel
    ../../../common/gpu/nvidia
    ../../../common/gpu/nvidia/kepler
    ../../../common/hidpi.nix
  ];

  boot = {
    initrd.kernelModules = [
      "applesmc"
      "applespi"
      "intel_lpss_pci"
      "spi_pxa2xx_platform"
      "kvm-intel"
    ];
    blacklistedKernelModules = [
      "b43"
      "ssb"
      "brcmfmac"
      "brcmsmac"
      "bcma"
    ];
    kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.0") pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  };

  hardware = {
    bluetooth.enable = lib.mkDefault true;
  };
}

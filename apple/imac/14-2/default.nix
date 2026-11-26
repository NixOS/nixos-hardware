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
    ../../../common/broadcom-wifi.nix
  ];
  # ##############################################################################
  # ATTENTION / IMPORTANT NOTE:
  #
  # Note: Enabling WiFi and Bluetooth functionality on this hardware requires
  # the proprietary Broadcom driver. Due to outstanding security issues, you
  # need to explicitly opt-in by setting:
  #
  # hardware.broadcom.wifi.enableLegacyDriverWithKnownVulnerabilities = true;
  # ##############################################################################
  config = {
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
    };

    hardware = {
      bluetooth.enable = lib.mkDefault true;
    };
  };
}

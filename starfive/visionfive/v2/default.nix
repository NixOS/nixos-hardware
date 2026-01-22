{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./firmware.nix
  ];

  boot = {
    consoleLogLevel = lib.mkDefault 7;
    # Switch to default as soon they reach >= 6.11
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    initrd.availableKernelModules = [ "dw_mmc_starfive" ];

    # Support booting SD-image from NVME SSD
    initrd.kernelModules = [
      "clk-starfive-jh7110-aon"
      "clk-starfive-jh7110-stg"
      "phy-jh7110-pcie"
      "pcie-starfive"
      "nvme"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  assertions = [
    {
      assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.11";
      message = "The VisionFive 2 requires at least mainline kernel version 6.11 for minimum hardware support.";
    }
  ];
}

{ config, lib, pkgs, ... }: {
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    # Switch to latest or LTE as soon they reach >= 6.11
    kernelPackages = lib.mkDefault pkgs.linuxPackages_testing;

    kernelParams = [ "console=tty0" "console=ttyS0,115200n8" "earlycon=sbi" ];

    initrd.availableKernelModules = [ "dw_mmc_starfive" ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.deviceTree.name =
    lib.mkDefault "starfive/jh7110-starfive-visionfive-2-v1.3b.dtb";

  hardware.deviceTree.overlays = [{
    name = "qspi-patch";
    dtsFile = ./qspi-patch.dts;
  }];

  assertions = [
    {
      assertion = (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.11");
      message = "The VisionFive 2 requires at least mainline kernel version 6.11 for minimum hardware support.";
    }
  ];
}

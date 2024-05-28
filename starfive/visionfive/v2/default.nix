{ config, lib, pkgs, ... }: {
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    kernelParams =
      lib.mkDefault [ "console=tty0" "console=ttyS0,115200n8" "earlycon=sbi" ];

    initrd.availableKernelModules = [ "dw_mmc_starfive" ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  hardware.deviceTree.name =
    lib.mkDefault "starfive/jh7110-starfive-visionfive-2-v1.3b.dtb";
}

{ config, lib, pkgs, ... }: {
  boot = {
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelPatches = [{
      name = "JH7110";
      patch = pkgs.fetchpatch {
        # https://patchwork.kernel.org/project/linux-riscv/patch/20240506034627.66765-1-hal.feng@starfivetech.com/
        name = "v2-riscv-defconfig-Enable-StarFive-JH7110-drivers.patch";
        url = "https://patchwork.kernel.org/series/850668/mbox/";
        hash = "sha256-81Brj61TOUoyVBxrXQh2VU3gTh/1V3uo33ic3sJPk2w=";
      };
    }];

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

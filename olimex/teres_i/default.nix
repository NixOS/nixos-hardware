{ lib, pkgs, ... }:

{
  hardware.deviceTree = {
    name = lib.mkDefault "allwinner/sun50i-a64-teres-i.dts";
    enable = lib.mkDefault true;
  };

  boot = {
    consoleLogLevel = lib.mkDefault 7;

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    kernelParams = lib.mkDefault [ "console=ttyS0,115200n8" ];
    extraModulePackages = lib.mkDefault [ ];

    initrd = {
      availableKernelModules = lib.mkDefault [ "usbhid" ];
      kernelModules = lib.mkDefault [ ];
    };

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}

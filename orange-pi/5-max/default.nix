{ lib, pkgs, ... }:
let
  orangepi-firmware = pkgs.callPackage ./orangepi-firmware.nix { };
in
{
  imports = [
    ./audio.nix
    ./wireless.nix
    ./graphics.nix
    ./leds.nix
    ./uart.nix
    ./uboot
    ../../common/gpu/24.05-compat.nix
  ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  boot = {
    kernelPackages =
      if (lib.versionOlder pkgs.linux.version "6.15") then
        lib.mkDefault pkgs.linuxPackages_latest
      else
        lib.mkDefault pkgs.linuxPackages;
    supportedFilesystems.zfs = false;

    kernelParams = [
      "rootwait"
      "consoleblank=0"
      "console=tty1"
    ];

    initrd.includeDefaultModules = false;
    initrd.availableKernelModules = [
      "nvme"
      "mmc_block"
      "usbhid"
      "hid_generic"
      "dm_mod"
      "input_leds"
    ];

    loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };
  };

  disabledModules = [ "profiles/all-hardware.nix" ];

  hardware = {
    deviceTree = {
      enable = lib.mkDefault true;
      name = lib.mkDefault "rockchip/rk3588-orangepi-5-max.dtb";
    };

    firmware = [ orangepi-firmware ];

    enableRedistributableFirmware = lib.mkDefault true;
  };

  networking.networkmanager.wifi.scanRandMacAddress = lib.mkDefault false;

  systemd.services."orangepi5-usb2-init" = {
    description = "Initialize USB2 on Orange Pi 5";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/sh -c 'echo host > /sys/kernel/debug/usb/fc000000.usb/mode'";
    };
  };
}

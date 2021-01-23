{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/acpi_call.nix
  ];

  # Use later kernel version so kernel attempts to load SOF firmware
  # instead of attempting Realtek emulation
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.9")
    pkgs.linuxPackages_latest;

  # Force S3 sleep mode.
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # touchpad goes sover i2c
  boot.blacklistedKernelModules = [ "psmouse" ];

  services.thermald.enable = lib.mkDefault true;
}

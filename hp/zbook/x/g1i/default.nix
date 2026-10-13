{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../../../common/cpu/intel
    ../../../../common/pc
    ../../../../common/pc/laptop
    ../../../../common/pc/ssd
  ];

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;
    intelgpu.vaapiDriver = lib.mkDefault "intel-media-driver";
  };

  services = {
    fwupd.enable = lib.mkDefault true;
    hardware.bolt.enable = lib.mkDefault true;
    thermald.enable = lib.mkDefault true;
  };

  # Arrow Lake support on this machine is still moving quickly upstream.
  boot = {
    kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.17") (
      lib.mkDefault pkgs.linuxPackages_latest
    );

    # Enables ACPI platform profiles.
    kernelModules = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.1") [ "hp-wmi" ];
  };
}

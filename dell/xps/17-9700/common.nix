{ lib, pkgs, ... }:

{
  # Boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  boot.kernelParams = lib.mkDefault [ "acpi_rev_override" ];
  boot.kernelModules = lib.mkDefault [ "kvm-intel" ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;

  # This will save you money and possibly your life!
  services.thermald.enable = lib.mkDefault true;

  boot.kernelPatches = [{
    name = "enable-soundwire-drivers";
    patch = null;
    extraConfig = ''
      SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES y
      SND_SOC_INTEL_SOUNDWIRE_SOF_MACH m
      SND_SOC_RT1308 m
    '';
    ignoreConfigErrors = true;
  }];

  boot.kernelPackages =
    lib.mkIf (lib.versionOlder pkgs.linux.version "5.11")
    pkgs.linuxPackages_latest;
}

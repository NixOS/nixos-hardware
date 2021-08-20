{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    # To just use Intel integrated graphics with Intel's open source driver
    ../../../common/gpu/nvidia-disable
  ];

  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
  # This saves power when the discrete GPU is not in use
  boot.kernelParams = lib.mkDefault [ "acpi_rev_override" ];

  # This will save you money and possibly your life!
  services.thermald.enable = true;

  boot.kernelPackages =
    lib.mkIf (lib.versionOlder pkgs.linux.version "5.11")
    pkgs.linuxPackages_latest;
}

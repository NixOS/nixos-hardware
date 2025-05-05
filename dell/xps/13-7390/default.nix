{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # older version break wifi:
  # - https://github.com/NixOS/nixos-hardware/issues/173
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.6") pkgs.linuxPackages_latest;

  # Cooling management
  services.thermald.enable = lib.mkDefault true;

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = lib.mkDefault true;
}

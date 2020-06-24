{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # older version break wifi:
  # - https://github.com/NixOS/nixos-hardware/issues/173
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.6") pkgs.linuxPackages_latest;

  services.thermald.enable = true;
}

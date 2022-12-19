{ config, lib, pkgs, ... }:

{

  imports = [
    ../../../../../common/cpu/amd
    ../../../../../common/gpu/amd
    ../../../../../common/pc/laptop/acpi_call.nix
  ];

  # For mainline support of rtw89 wireless networking
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_6_1;
}

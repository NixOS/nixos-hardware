{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/amd
    ../../../../common/gpu/amd
  ];

  # For support of newer AMD GPUs, backlight and internal microphone
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.8") pkgs.linuxPackages_latest;
}

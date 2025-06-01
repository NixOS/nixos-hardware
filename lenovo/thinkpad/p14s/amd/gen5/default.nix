{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../../common/cpu/amd/pstate.nix
  ];

  # For the Qualcomm NFA-725A (Device 1103) wireless network controller
  # See https://bugzilla.redhat.com/show_bug.cgi?id=2047878
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") pkgs.linuxPackages_latest;
}

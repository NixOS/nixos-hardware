{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../../../common/cpu/amd/pstate.nix
  ];

  # For support of MEDIATEK Corp. Device 7961 wireless network controller, see https://lwn.net/Articles/843303/
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.12") pkgs.linuxPackages_latest;
}

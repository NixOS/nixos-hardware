{ pkgs, lib, ... }:
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../battery.nix
  ];

  # 6.5 adds many fixes and improvements for the Ally
  # This includes for example performance, audio and bluetooth
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.5") (
    lib.mkDefault pkgs.linuxPackages_latest
  );
}

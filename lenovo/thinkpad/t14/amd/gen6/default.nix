{
  lib,
  pkgs,
  config,
  ...
}:

{
  imports = [
    ../.
    ../../../../../common/cpu/amd/pstate.nix
    ../../../../../common/wifi/mediatek/mt7925
  ];

  # recommended for the mt7925 wireless adapter
  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.18") pkgs.linuxPackages_latest;

}

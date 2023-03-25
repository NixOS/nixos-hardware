{ lib, pkgs, ... }:
lib.optionalAttrs (lib.versionOlder (lib.versions.majorMinor lib.version) "23.05") {
  # This option is removed from NixOS 23.05 and up
  hardware.video.hidpi.enable = lib.mkDefault true;
}

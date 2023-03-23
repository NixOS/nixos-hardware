{ lib, pkgs, ... }:
let
  # This option is removed from NixOS 23.05 and up
  nixosVersion = lib.versions.majorMinor lib.version;
  config = if lib.versionOlder nixosVersion "23.05" then {
    hardware.video.hidpi.enable = lib.mkDefault true;
  } else {
    # Just set the console font, don't mess with the font settings
    console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    console.earlySetup = lib.mkDefault true;
  };
in config

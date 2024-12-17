{ lib, pkgs, ... }:
with lib;
{
  imports = [
    ../../../common/cpu/amd/raphael/igpu.nix
    ./bluetooth.nix
    ./amd.nix
    ./audio.nix
    ./power
  ];

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  boot.extraModprobeConfig = mkIf (versionOlder pkgs.linux.version "6.6.8") ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = mkDefault true;
}

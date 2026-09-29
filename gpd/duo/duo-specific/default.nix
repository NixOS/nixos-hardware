{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  hasGpdFan = versionAtLeast config.boot.kernelPackages.kernel.version "6.18";
in
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

  # gpd_fan was merged into mainline in Linux 6.18: https://docs.kernel.org/hwmon/gpd-fan.html
  boot.initrd.kernelModules = mkIf hasGpdFan [ "gpd_fan" ];
  boot.kernelModules = mkIf hasGpdFan [ "gpd_fan" ];

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = mkDefault true;
}

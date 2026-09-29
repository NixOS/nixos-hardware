{ config, lib, ... }:
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

  # gpd_fan was merged into mainline in Linux 6.18: https://docs.kernel.org/hwmon/gpd-fan.html
  boot.initrd.kernelModules = mkIf hasGpdFan [ "gpd_fan" ];
  boot.kernelModules = mkIf hasGpdFan [ "gpd_fan" ];

  # Needed for desktop environments to detect/manage display brightness
  hardware.sensor.iio.enable = mkDefault true;
}

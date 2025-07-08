{ config, lib, ... }:
with lib;
{
  imports = [
    ./..
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
    ./bmi260
  ];

  hardware.sensor.iio.bmi260.enable = lib.mkDefault true;

  #see README
  boot.blacklistedKernelModules = mkIf config.hardware.sensor.iio.bmi260.enable [
    "bmi160_spi"
    "bmi160_i2c"
    "bmi160_core"
  ];
  hardware.sensor.iio.enable = mkIf config.hardware.sensor.iio.bmi260.enable true;
}

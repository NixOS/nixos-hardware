{ config, lib, ... }:

with lib;

let

  bmi260 = config.boot.kernelPackages.callPackage ./package.nix { };

in
{

  meta.maintainers = [ maintainers.Cryolitia ];

  ###### interface

  options = {

    hardware.sensor.iio.bmi260.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable Bosch BMI260 IMU kernel module driver.
      '';
    };
  };

  ###### implementation

  config = mkIf config.hardware.sensor.iio.bmi260.enable {
    boot.extraModulePackages = [ bmi260 ];
    boot.kernelModules = [
      "bmi260_core"
      "bmi260_i2c"
    ];
  };
}

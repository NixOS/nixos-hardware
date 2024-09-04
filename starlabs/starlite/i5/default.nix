{ lib, pkgs, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  # Turn on IIO for accelerometer screen rotation.
  hardware.sensor.iio.enable = lib.mkDefault true;

  # Accelerometer is mounted to display with inverted Y axis. Adjust!
  services.udev.extraHwdb = ''
    sensor:modalias:acpi:KIOX000A*:dmi:*:*
      ACCEL_MOUNT_MATRIX=1, 0, 0; 0, -1, 0; 0, 0, 1
  '';
}

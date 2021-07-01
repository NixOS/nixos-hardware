{ config, lib, pkgs, ... }:

{
  # automatic screen orientation
  hardware.sensor.iio.enable = true;
}

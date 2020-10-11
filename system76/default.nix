# Implementation of support for general System76 hardware.
#
# https://system76.com/

{ config, lib, ... }:
{
  imports = [ ../common/pc ];

  # This seems to be required for system76-driver.
  boot.kernelParams = [ "ec_sys.write_support=1" ];

  hardware.system76.enableAll = lib.mkDefault true;
}

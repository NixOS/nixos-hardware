# Implementation of support for general System76 hardware.
#
# https://system76.com/

{ config, lib, ... }:
{
  imports = [ ../common/pc ];

  hardware.system76.enableAll = lib.mkDefault true;
}

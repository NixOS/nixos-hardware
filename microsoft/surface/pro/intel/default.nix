{ lib, pkgs, ... }:

with lib;

# This module is intended to support the Surface Pro range, specifically those with Intel CPUs.
# It's expected it will work equally well on many other Surface models, but they may need further
# config changes to work well.

{
  imports = [
    ../../common
    ../../../../common/pc
    ../../../../common/pc/ssd
    # The Intel CPU module auto-includes Intel's GPU:
    ../../../../common/cpu/intel
    ../../../../common/pc/laptop
  ];

  services.iptsd.enable = mkDefault true;
  environment.systemPackages = [ pkgs.surface-control ];

  services.thermald = [
    enable = mkDefault true;
    configFile = mkDefault ./thermal-conf.xml;
  ];
}

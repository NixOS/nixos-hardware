{ lib, ... }:

{
  imports = [
    ../../../../common/pc/ssd
    ../../../../common/cpu/intel/lunar-lake
  ];

  hardware.trackpoint.device = "TPPS/2 Synaptics TrackPoint";

  services.thermald.enable = lib.mkDefault true;
}

{ lib, ... }:
{
  imports = [
    ../.
    ../../../common/pc/ssd
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.trackpoint.device = lib.mkDefault "TPPS/2 Elan TrackPoint";
}

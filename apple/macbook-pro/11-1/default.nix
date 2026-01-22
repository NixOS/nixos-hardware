{ lib, config, ... }:
{
  imports = [
    ../.
    ../../../common/pc/ssd
    ../../../common/cpu/intel/haswell
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
}

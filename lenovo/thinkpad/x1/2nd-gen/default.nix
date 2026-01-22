{ lib, ... }:
{
  imports = [
    ../.
    ../../../../common/cpu/intel/haswell
    ../../../../common/pc/ssd
  ];

  services.throttled.enable = lib.mkDefault true;
}

{ lib, ... }:
{
  imports = [
    ../.
    ../../../../common/cpu/intel/haswell
    ../../../../common/pc/laptop/ssd
  ];

  services.throttled.enable = lib.mkDefault true;
}

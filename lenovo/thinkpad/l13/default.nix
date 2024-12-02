{ lib, ... }:
{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop/ssd
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;
}

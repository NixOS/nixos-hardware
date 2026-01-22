{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/ssd
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;
}

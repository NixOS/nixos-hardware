{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/kaby-lake
    ../../../common/pc/ssd
    ../.
  ];

  services.throttled.enable = lib.mkDefault true;
}

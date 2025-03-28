{ lib, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/intel/comet-lake
  ];

  services.throttled.enable = lib.mkDefault true;
}

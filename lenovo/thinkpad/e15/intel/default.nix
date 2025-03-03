{ lib, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/intel/alder-lake
  ];

  services.throttled.enable = lib.mkDefault true;
}

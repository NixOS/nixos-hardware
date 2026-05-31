{ lib, ... }:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/arrow-lake
  ];

  services.throttled.enable = lib.mkDefault false;
}

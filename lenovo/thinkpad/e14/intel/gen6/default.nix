{ lib, ... }:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/meteor-lake
  ];

  services.throttled.enable = lib.mkDefault false;
}

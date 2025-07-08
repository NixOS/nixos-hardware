{ lib, ... }:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/alder-lake
  ];

  services.throttled.enable = lib.mkDefault false;
  hardware.intelgpu.driver = "xe";
}

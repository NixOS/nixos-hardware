{ lib, ... }:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/raptor-lake
  ];

  services.throttled.enable = lib.mkDefault false;
  hardware.intelgpu.driver = "xe";
}

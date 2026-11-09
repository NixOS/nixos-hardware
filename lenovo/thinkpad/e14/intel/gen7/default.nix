{ lib, ... }:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/raptor-lake
  ];

  hardware.intelgpu.driver = "xe";
  services.throttled.enable = lib.mkDefault false;
}

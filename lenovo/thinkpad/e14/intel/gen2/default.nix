{ lib, ... }:

{
  imports = [
    ../../.
    ../../../../../common/cpu/intel/tiger-lake
  ];

  services.throttled.enable = lib.mkDefault false;
  hardware.intelgpu.driver = "xe";
}

{ lib, ... }:

{
  imports = [
    ../.
    ../../../../common/cpu/intel/comet-lake
  ];

  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  services.throttled.enable = lib.mkDefault true;
}

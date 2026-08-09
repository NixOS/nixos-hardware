{ lib, ... }:

{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/cpu/intel/ice-lake
  ];

  hardware.intelgpu = {
    vaapiDriver = lib.mkDefault "intel-media-driver";
  };

  services.thermald.enable = lib.mkDefault true;
}

{ lib, ... }:

{
  imports = [
    ../../../common/pc/laptop
    ../../../common/pc/ssd
    ../../../common/cpu/intel/ice-lake
  ];

  hardware.intelgpu.computeRuntime = lib.mkDefault "legacy";

  services.thermald.enable = lib.mkDefault true;
}

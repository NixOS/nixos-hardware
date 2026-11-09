{ config, lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  hardware.intelgpu = {
    driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") (
      lib.mkDefault "xe"
    );
    vaapiDriver = lib.mkDefault "intel-media-driver";
  };

  hardware.cpu.intel.npu.enable = lib.mkDefault true;

  services.thermald.enable = lib.mkDefault true;
}

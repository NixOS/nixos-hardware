{
  config,
  lib,
  ...
}:
{
  imports = [
    ../../../common/cpu/intel/tiger-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../battery.nix
  ];

  # while tiger-lake in general not supported by xe, some chipsets like this one are.
  hardware.intelgpu.driver = lib.mkIf (lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8") "xe";

  boot.kernelParams = lib.mkIf (config.hardware.intelgpu.driver == "xe") [
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../../../common/gpu/intel/tiger-lake
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
    ../../battery.nix
  ];

  boot.kernelParams = lib.mkIf (config.hardware.intelgpu.driver == "xe") [
    "i915.force_probe=!9a49"
    "xe.force_probe=9a49"
  ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  services.thermald.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

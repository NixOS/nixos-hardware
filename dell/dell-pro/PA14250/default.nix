{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel/lunar-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  hardware.intelgpu.driver = "xe";
  # use xe graphics module, i915 doesn't seem to work well
  # just selecting xe seems to be not enough
  boot.blacklistedKernelModules = [ "i915" ];

  boot.kernelParams = [
    # makes external display more stable
    "xe.psr_safest_params=1"
    # extra debug logs just in case something breaks
    "xe.verbose_state_checks=true"
  ];

  # 6.15.5 and 6.12.34 seems to work, newer versions in 25.05 fail to load graphics
  # TODO: find or file upstream issue
  # meanwhile on 25.05 you can use
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  assertions = [
    {
      assertion = config.boot.kernelPackages.kernel.version != "6.12.35";
      message = "probe with driver xe failed with error -110";
    }
    {
      assertion = config.boot.kernelPackages.kernel.version != "6.12.36";
      message = "probe with driver xe failed with error -110";
    }
  ];

  # Recommended in NixOS/nixos-hardware#127
  services.thermald.enable = lib.mkDefault true;
}

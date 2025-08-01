{ lib, ... }:

# Xe module fails to load on 6.12.x starting 6.12.35
# tested to work on 6.13.4 or newer
#
# Bisect points at d42b44736ea29fa6d0c3cb9c75569314134b7732 but
# 6.13 series 30d105577a3319094f8ae5ff1ceea670f1931487 looks identical
# so it has to be not just that commit but its interactions with 6.12
# driver version
#
# https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5373
let
  brokenXeModule = version: lib.versionAtLeast version "6.12.35" && lib.versionOlder version "6.12.41";
in
{
  imports = [
    ../../../common/cpu/intel/lunar-lake
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  hardware.intelgpu.driver = "xe";

  boot = lib.mkMerge [
    {
      # use xe graphics module, i915 doesn't seem to work well
      # just selecting xe seems to be not enough
      blacklistedKernelModules = [ "i915" ];

      kernelParams = [
        # makes external display more stable
        "xe.psr_safest_params=1"
        # extra debug logs just in case something breaks
        "xe.verbose_state_checks=true"
      ];
    }

    # we can't inspect config.boot.kernelPackages.kernel.version to override kernelPackages as it's create a loop
    # instead let's auto-apply latest kernel if linux_default is broken
    #
    # TODO: this may unnecessarily bump kernel to latest if say 6.13 is manually selected in configuration
    #       maybe we need extra parameter to this module? Though should still already be possible to overrule module kernel selection.
    #       Looking at linux_default version is also less restrictive than always setting latest,
    #       once 6.12 is fixed we can update brokenXeModule expression and only do override on old nixpkgs versions that haven't yet
    #       upgraded to a fixed kernel
    (lib.mkIf (brokenXeModule pkgs.linuxKernel.packageAliases.linux_default.kernel.version) {
      kernelPackages = pkgs.linuxPackages_latest;
    })
  ];

  assertions = lib.optionals (config.hardware.intelgpu.driver == "xe") [
    {
      assertion = !(brokenXeModule config.boot.kernelPackages.kernel.version);
      message = "xe driver would fail with 'probe with driver xe failed with error -110'";
    }
  ];

  # Recommended in NixOS/nixos-hardware#127
  services.thermald.enable = lib.mkDefault true;
}

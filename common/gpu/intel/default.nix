{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [ ../24.05-compat.nix ];
  options.hardware.intelgpu.driver = lib.mkOption {
    description = "Intel GPU driver to use";
    type = lib.types.enum [
      "i915"
      "xe"
    ];
    default = "i915";
  };

  options.hardware.intelgpu.loadInInitrd =
    lib.mkEnableOption "Load the Intel GPU kernel module at stage 1 boot. (Added to `boot.initrd.kernelModules`)"
    // {
      default = true;
    };

  config = {
    boot.initrd.kernelModules = lib.optionals config.hardware.intelgpu.loadInInitrd [
      config.hardware.intelgpu.driver
    ];

    hardware.graphics.extraPackages = with pkgs; [
      (
        if pkgs?intel-vaapi-driver then
          intel-vaapi-driver
        else if pkgs?vaapiIntel then
          vaapiIntel
        else
          builtins.throw "Unable to find Intel VAAPI driver"
      )
      intel-media-driver
      (
        if pkgs?vpl-gpu-rt then
          vpl-gpu-rt
        else if pkgs?onevpl-intel-gpu then
          onevpl-intel-gpu
        else
          builtins.throw "Unable to find OneAPI VAAPI driver"
      )
    ];

    hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
      (
        if pkgs?intel-vaapi-driver then
          intel-vaapi-driver
        else if pkgs?vaapiIntel then
          vaapiIntel
        else
          builtins.throw "Unable to find Intel VAAPI driver"
      )
      intel-media-driver
      (
        if pkgs?vpl-gpu-rt then
          vpl-gpu-rt
        else if pkgs?onevpl-intel-gpu then
          onevpl-intel-gpu
        else
          builtins.throw "Unable to find OneAPI VAAPI driver"
      )
    ];

    assertions = [
      {
        assertion = (
          config.hardware.intelgpu.driver != "xe"
          || lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.8"
        );
        message = "Intel Xe GPU driver is not supported on kernels earlier than 6.8. Update or use the i915 driver.";
      }
    ];
  };
}

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
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver
      )
      intel-media-driver
    ];

    hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver
      )
      intel-media-driver
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

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hardware.intelgpu.driver = lib.mkOption {
    description = "Intel GPU driver to use";
    type = lib.types.enum [
      "i915"
      "xe"
    ];
    default = "i915";
  };

  options.hardware.intelgpu.loadInInitrd =
    lib.mkEnableOption (
      lib.mdDoc "Load the Intel GPU kernel module at stage 1 boot. (Added to `boot.initrd.kernelModules`)"
    )
    // {
      default = true;
    };

  config = {
    boot.initrd.kernelModules = [ config.hardware.intelgpu.driver ];

    environment.variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };

    hardware.opengl.extraPackages = with pkgs; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver
      )
      libvdpau-va-gl
      intel-media-driver
    ];

    hardware.opengl.extraPackages32 = with pkgs.driversi686Linux; [
      (
        if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then
          vaapiIntel
        else
          intel-vaapi-driver
      )
      libvdpau-va-gl
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

{
  config,
  lib,
  ...
}:
{
  options.hardware.framework.enableKmod =
    (lib.mkEnableOption "the community-created Framework kernel module that allows interacting with the embedded controller from sysfs.")
    // {
      # enable by default on NixOS >= 24.05 and kernel >= 6.10
      default = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.10";
      defaultText = "enabled by default if kernel >= 6.10";
    };

  config = lib.mkIf config.hardware.framework.enableKmod {
    assertions = [
      {
        assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.10";
        message = "The framework laptop kernel module requires Linux 6.10 or above";
      }
    ];

    boot = {
      extraModulePackages = with config.boot.kernelPackages; [
        framework-laptop-kmod
      ];

      # https://github.com/DHowett/framework-laptop-kmod?tab=readme-ov-file#usage
      kernelModules = [
        "cros_ec"
        "cros_ec_lpcs"
      ];
    };
  };
}

{ config, lib, ... }:
{
  options.hardware.framework.enableKmod = lib.mkEnableOption
    "Enable the community created Framework kernel module that allows interacting with the embedded controller from sysfs."
  // {
    # Enable by default if on new enough version of NixOS
    default = (lib.versionAtLeast (lib.versions.majorMinor lib.version) "24.05");
  };

  config = lib.mkIf config.hardware.framework.enableKmod {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];
    # https://github.com/DHowett/framework-laptop-kmod?tab=readme-ov-file#usage
    boot.kernelModules = [ "cros_ec" "cros_ec_lpcs" ];
  };
}

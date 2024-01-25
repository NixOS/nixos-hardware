{ config, lib, ... }:
{
  options.hardware.framework.enableKmod = lib.mkOption {
    type = lib.types.bool;
    # Enable by default if on new enough version of NixOS
    default = (lib.versionAtLeast (lib.versions.majorMinor lib.version) "24.05");
    description = ''
      Enable the community created Framework kernel module that
      allows interacting with the embedded controller from sysfs.
    '';
  };

  config = lib.mkIf options.hardware.framework.enableKmod {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      framework-laptop-kmod
    ];
  };
}

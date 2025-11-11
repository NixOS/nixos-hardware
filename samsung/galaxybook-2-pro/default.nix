###
# Kernel module by Joshua Grisham, added features in readme
# https://github.com/joshuagrisham/samsung-galaxybook-extras
# only use it for kernel versions <6.14 default is disabled but you can deactivate with:
# hardware.samsung-galaxybook.enableKmod =  false;
{
  lib,
  pkgs,
  config,
  ...
}: let
  kernel_version_compatible = lib.versionOlder config.boot.kernelPackages.kernel.version "6.14";
in {
  imports = [
    ../../common/cpu/intel/alder-lake
    ../../common/gpu/intel/alder-lake
    ../../common/pc/ssd
    ../../common/pc/laptop
  ];

  options.hardware.samsung-galaxybook.enableKmod =
    (
      lib.mkEnableOption
      "Enable the community created Samsung Galaxy Book kernel module that allows for additional features and functionality"
    )
    // {
      default = kernel_version_compatible;
      defaultText = "enabled by default on kernel < 6.14";
    };

  config = lib.mkMerge [
    (
      lib.mkIf config.hardware.samsung-galaxybook.enableKmod {
        boot.extraModulePackages = [
          (pkgs.callPackage ./kernel-module.nix {
            kernel = config.boot.kernelPackages.kernel;
          })
        ];
      }
    )
    {
      boot.kernelModules = ["kvm-intel"];
      boot.kernelParams = ["i915.enable_dpcd_backlight=3"];
      boot.initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod"];
      services.fprintd.enable = lib.mkDefault true;
    }
  ];
}

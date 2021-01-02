{ config, lib, pkgs, ... }:
let
  repos = (pkgs.callPackage ./repos.nix {});
  # TODO: Can I append the path ./patches instead of a string?
  patches = repos.linux-surface + "/patches";
  kernelVersions = {
    linux_5_4_7 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.4/linux-5.4.7.nix { kernelPatches = []; }
          )
        )
      );

      kernelPatches = [
        {
          name = "ms-surface/0001-surface3-power";
          patch = ./5.4/0001-surface3-power.patch;
        }
        {
          name = "ms-surface/0002-surface3-spi";
          patch = ./5.4/0002-surface3-spi.patch;
        }
        {
          name = "ms-surface/0003-surface3-oemb";
          patch = ./5.4/0003-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0004-ioremap_uc";
          patch = ./5.4/0004-ioremap_uc.patch;
        }
        {
          name = "ms-surface/0005-surface-sam";
          patch = ./5.4/0005-surface-sam.patch;
        }
        {
          name = "ms-surface/0006-surface-lte";
          patch = ./5.4/0006-surface-lte.patch;
        }
        {
          name = "ms-surface/0007-wifi";
          patch = ./5.4/0007-wifi.patch;
        }
      ];
    };

    linux_5_4_11 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.4/linux-5.4.11.nix {
              kernelPatches = [
                kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "ms-surface/0001-surface3-power";
          patch = ./5.4/0001-surface3-power.patch;
        }
        {
          name = "ms-surface/0002-surface3-spi";
          patch = ./5.4/0002-surface3-spi.patch;
        }
        {
          name = "ms-surface/0003-surface3-oemb";
          patch = ./5.4/0003-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0004-ioremap_uc";
          patch = ./5.4/0004-ioremap_uc.patch;
        }
        {
          name = "ms-surface/0005-surface-sam";
          patch = ./5.4/0005-surface-sam.patch;
        }
        {
          name = "ms-surface/0006-surface-lte";
          patch = ./5.4/0006-surface-lte.patch;
        }
        {
          name = "ms-surface/0007-wifi";
          patch = ./5.4/0007-wifi.patch;
        }
      ];
    };

    linux_5_4_13 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.4/linux-5.4.13.nix {
              kernelPatches = [
                kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                # kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "ms-surface/0001-surface3-power";
          patch = ./5.4/0001-surface3-power.patch;
        }
        {
          name = "ms-surface/0002-surface3-spi";
          patch = ./5.4/0002-surface3-spi.patch;
        }
        {
          name = "ms-surface/0003-surface3-oemb";
          patch = ./5.4/0003-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0004-ioremap_uc";
          patch = ./5.4/0004-ioremap_uc.patch;
        }
        {
          name = "ms-surface/0005-surface-sam";
          patch = ./5.4/0005-surface-sam.patch;
        }
        {
          name = "ms-surface/0006-surface-lte";
          patch = ./5.4/0006-surface-lte.patch;
        }
        {
          name = "ms-surface/0007-wifi";
          patch = ./5.4/0007-wifi.patch;
        }
      ];
    };

    linux_5_4_16 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.4/linux-5.4.16.nix {
              kernelPatches = [
                kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                # kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "ms-surface/0001-surface3-power";
          patch = ./5.4/0001-surface3-power.patch;
        }
        {
          name = "ms-surface/0002-surface3-spi";
          patch = ./5.4/0002-surface3-spi.patch;
        }
        {
          name = "ms-surface/0003-surface3-oemb";
          patch = ./5.4/0003-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0004-ioremap_uc";
          patch = ./5.4/0004-ioremap_uc.patch;
        }
        {
          name = "ms-surface/0005-surface-sam";
          patch = ./5.4/0005-surface-sam.patch;
        }
        {
          name = "ms-surface/0006-surface-lte";
          patch = ./5.4/0006-surface-lte.patch;
        }
        {
          name = "ms-surface/0007-wifi";
          patch = ./5.4/0007-wifi.patch;
        }
      ];
    };

    linux_5_4_22 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.4/linux-5.4.22.nix {
              kernelPatches = [
                kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                # kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "ms-surface/0001-surface3-power";
          patch = ./5.4/0001-surface3-power.patch;
        }
        {
          name = "ms-surface/0002-surface3-spi";
          patch = ./5.4/0002-surface3-spi.patch;
        }
        {
          name = "ms-surface/0003-surface3-oemb";
          patch = ./5.4/0003-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0004-ioremap_uc";
          patch = ./5.4/0004-ioremap_uc.patch;
        }
        {
          name = "ms-surface/0005-surface-sam";
          patch = ./5.4/0005-surface-sam.patch;
        }
        {
          name = "ms-surface/0006-surface-lte";
          patch = ./5.4/0006-surface-lte.patch;
        }
        {
          name = "ms-surface/0007-wifi";
          patch = ./5.4/0007-wifi.patch;
        }
        {
          name = "ms-surface/0008-ipts";
          patch = ./5.4/0008-ipts.patch;
        }
      ];
    };


    linux_5_4_24 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.4/linux-5.4.24.nix {
              kernelPatches = [
                kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                # kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "ms-surface/0001-surface3-power";
          patch = ./5.4/0001-surface3-power.patch;
        }
        {
          name = "ms-surface/0002-surface3-spi";
          patch = ./5.4/0002-surface3-spi.patch;
        }
        {
          name = "ms-surface/0003-surface3-oemb";
          patch = ./5.4/0003-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0004-ioremap_uc";
          patch = ./5.4/0004-ioremap_uc.patch;
        }
        {
          name = "ms-surface/0005-surface-sam";
          patch = ./5.4/0005-surface-sam.patch;
        }
        {
          name = "ms-surface/0006-surface-lte";
          patch = ./5.4/0006-surface-lte.patch;
        }
        {
          name = "ms-surface/0007-wifi";
          patch = ./5.4/0007-wifi.patch;
        }
        {
          name = "ms-surface/0008-ipts";
          patch = ./5.4/0008-ipts.patch;
        }
      ];
    };

    linux_5_5_8 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.5/linux-5.5.8.nix {
              kernelPatches = [
                kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                # kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "microsoft-surface-config";
          patch = null;
          extraConfig = ''
            SURFACE_SAM_SSH_DEBUG_DEVICE y
          '';
          # extraConfig = ''
          #   SURFACE_SAM m
          #   SURFACE_SAM_SSH m
          #   SURFACE_SAM_SSH_DEBUG_DEVICE y
          #   SURFACE_SAM_SAN m
          #   SURFACE_SAM_VHF m
          #   SURFACE_SAM_DTX m
          #   SURFACE_SAM_HPS m
          #   SURFACE_SAM_SID m
          #   SURFACE_SAM_SID_GPELID m
          #   SURFACE_SAM_SID_PERFMODE m
          #   SURFACE_SAM_SID_VHF m
          #   SURFACE_SAM_SID_POWER m
          #   TOUCHSCREEN_IPTS m
          #   INPUT_SOC_BUTTON_ARRAY m
          #   SURFACE_3_POWER_OPREGION m
          #   SURFACE_3_BUTTON m
          #   SURFACE_3_POWER_OPREGION m
          #   SURFACE_PRO3_BUTTON m
          # '';
        }
        {
          name = "ms-surface/0001-surface3-power";
          patch = ./5.5/0001-surface3-power.patch;
        }
        {
          name = "ms-surface/0002-surface3-spi";
          patch = ./5.5/0002-surface3-spi.patch;
        }
        {
          name = "ms-surface/0003-surface3-oemb";
          patch = ./5.5/0003-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0004-surface-sam";
          patch = ./5.5/0004-surface-sam.patch;
        }
        {
          name = "ms-surface/0005-surface-lte";
          patch = ./5.5/0005-surface-lte.patch;
        }
        {
          name = "ms-surface/0006-wifi";
          patch = ./5.5/0006-wifi.patch;
        }
        {
          name = "ms-surface/0007-ipts";
          patch = ./5.5/0007-ipts.patch;
        }
      ];
    };

    linux_5_9_2 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./5.9/linux-5.9.2.nix {
              kernelPatches = [
                # kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                # kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "microsoft-surface-config";
          patch = null;
          extraConfig = ''
            #
            # Surface Aggregator Module
            #
            # required for SURFACE_HOTPLUG:
            GPIO_SYSFS y
            SURFACE_AGGREGATOR m
            SURFACE_AGGREGATOR_ERROR_INJECTION n
            SURFACE_AGGREGATOR_BUS y
            SURFACE_AGGREGATOR_CDEV m
            SURFACE_AGGREGATOR_REGISTRY m
            SURFACE_ACPI_NOTIFY m
            SURFACE_BATTERY m
            SURFACE_DTX m
            SURFACE_HID m
            SURFACE_HOTPLUG m
            SURFACE_PERFMODE m

            #
            # IPTS touchscreen
            #
            # This only enables the user interface for IPTS data.
            # For the touchscreen to work, you need to install iptsd.
            #
            MISC_IPTS m

            #
            # Other Drivers
            #
            INPUT_SOC_BUTTON_ARRAY m
            SURFACE_3_BUTTON m
            SURFACE_3_POWER_OPREGION m
            SURFACE_PRO3_BUTTON m
            SURFACE_GPE m
            SURFACE_BOOK1_DGPU_SWITCH m
          '';
        }
        {
          name = "ms-surface/0001-surface3-oemb";
          patch = ./5.9/0001-surface3-oemb.patch;
        }
        {
          name = "ms-surface/0002-wifi";
          patch = ./5.9/0002-wifi.patch;
        }
        {
          name = "ms-surface/0003-ipts";
          patch = ./5.9/0003-ipts.patch;
        }
        {
          name = "ms-surface/0004-surface-gpe";
          patch = ./5.9/0004-surface-gpe.patch;
        }
        {
          name = "ms-surface/0005-surface-sam-over-hid";
          patch = ./5.9/0005-surface-sam-over-hid.patch;
        }
        {
          name = "ms-surface/0006-surface-sam";
          patch = ./5.9/0006-surface-sam.patch;
        }
        # {
        #   name = "ms-surface/0007-i2c-core-Restore-acpi_walk_dep_device_list-getting-c";
        #   patch = ./5.9/0007-i2c-core-Restore-acpi_walk_dep_device_list-getting-c.patch;
        # }
      ];
    };

    linux_5_10_4 = {
      kernelPackages = (with pkgs;
        recurseIntoAttrs (
          linuxPackagesFor (
            callPackage ./linux-5.10.4.nix {
              kernelPatches = [
                # kernelPatches.bridge_stp_helper
                # kernelPatches.request_key_helper
                # kernelPatches.export_kernel_fpu_functions
              ];
            }
          )
        )
      );

      kernelPatches = [
        {
          name = "microsoft-surface-config";
          patch = null;
          extraConfig = ''
            #
            # Surface Aggregator Module
            #
            # required for SURFACE_HOTPLUG:
            GPIO_SYSFS y
            SURFACE_AGGREGATOR m
            SURFACE_AGGREGATOR_ERROR_INJECTION n
            SURFACE_AGGREGATOR_BUS y
            SURFACE_AGGREGATOR_CDEV m
            SURFACE_AGGREGATOR_REGISTRY m
            SURFACE_ACPI_NOTIFY m
            SURFACE_BATTERY m
            SURFACE_DTX m
            SURFACE_HID m
            SURFACE_HOTPLUG m
            SURFACE_PERFMODE m

            #
            # IPTS touchscreen
            #
            # This only enables the user interface for IPTS data.
            # For the touchscreen to work, you need to install iptsd.
            #
            MISC_IPTS m

            #
            # Other Drivers
            #
            INPUT_SOC_BUTTON_ARRAY m
            SURFACE_3_BUTTON m
            SURFACE_3_POWER_OPREGION m
            SURFACE_PRO3_BUTTON m
            SURFACE_GPE m
            SURFACE_BOOK1_DGPU_SWITCH m
          '';
        }
        {
          name = "ms-surface/0001-surface3-oemb";
          patch = patches + "/5.10/0001-surface3-oemb.patch";
        }
        {
          name = "ms-surface/0002-wifi";
          patch = patches + "/5.10/0002-wifi.patch";
        }
        {
          name = "ms-surface/0003-ipts";
          patch = patches + "/5.10/0003-ipts.patch";
        }
        {
          name = "ms-surface/0004-surface-gpe";
          patch = patches + "/5.10/0004-surface-gpe.patch";
        }
        {
          name = "ms-surface/0005-surface-sam-over-hid";
          patch = patches + "/5.10/0005-surface-sam-over-hid.patch";
        }
        {
          name = "ms-surface/0006-surface-sam";
          patch = patches + "/5.10/0006-surface-sam.patch";
        }
        {
          name = "ms-surface/0007-surface-hotplug";
          patch = patches + "/5.10/0007-surface-hotplug.patch";
        }
        {
          name = "ms-surface/0008-surface-typecover";
          patch = patches + "/5.10/0008-surface-typecover.patch";
        }
        {
          name = "ms-surface/0009-cameras";
          patch = patches + "/5.10/0009-cameras.patch";
        }
      ];
    };
  };
in {
  boot.kernelPackages = kernelVersions.linux_5_10_4.kernelPackages;
  boot.kernelPatches = kernelVersions.linux_5_10_4.kernelPatches;
}

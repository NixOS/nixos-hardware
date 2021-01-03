{ config, lib, pkgs, ... }:
let
  repos = (pkgs.callPackage ../repos.nix {});
  # TODO: Can I append the path ./patches instead of a string?
  patches = repos.linux-surface + "/patches";
  surface_kernelPatches = {
    linux_5_4 = [
      {
        name = "ms-surface/0001-surface3-power";
        patch = patches + "/5.4/0001-surface3-power.patch";
      }
      {
        name = "ms-surface/0002-surface3-spi";
        patch = patches + "/5.4/0002-surface3-spi.patch";
      }
      {
        name = "ms-surface/0003-surface3-oemb";
        patch = patches + "/5.4/0003-surface3-oemb.patch";
      }
      {
        name = "ms-surface/0004-ioremap_uc";
        patch = patches + "/5.4/0004-ioremap_uc.patch";
      }
      {
        name = "ms-surface/0005-surface-sam";
        patch = patches + "/5.4/0005-surface-sam.patch";
      }
      {
        name = "ms-surface/0006-surface-lte";
        patch = patches + "/5.4/0006-surface-lte.patch";
      }
      {
        name = "ms-surface/0007-wifi";
        patch = patches + "/5.4/0007-wifi.patch";
      }
      {
        name = "ms-surface/0008-ipts";
        patch = patches + "/5.4/0008-ipts.patch";
      }
    ];

    linux_5_5 = [
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
        patch = patches + "/5.5/0001-surface3-power.patch";
      }
      {
        name = "ms-surface/0002-surface3-spi";
        patch = patches + "/5.5/0002-surface3-spi.patch";
      }
      {
        name = "ms-surface/0003-surface3-oemb";
        patch = patches + "/5.5/0003-surface3-oemb.patch";
      }
      {
        name = "ms-surface/0004-surface-sam";
        patch = patches + "/5.5/0004-surface-sam.patch";
      }
      {
        name = "ms-surface/0005-surface-lte";
        patch = patches + "/5.5/0005-surface-lte.patch";
      }
      {
        name = "ms-surface/0006-wifi";
        patch = patches + "/5.5/0006-wifi.patch";
      }
      {
        name = "ms-surface/0007-ipts";
        patch = patches + "/5.5/0007-ipts.patch";
      }
    ];

    linux_5_9 = [
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
        patch = patches + "/5.9/0001-surface3-oemb.patch";
      }
      {
        name = "ms-surface/0002-wifi";
        patch = patches + "/5.9/0002-wifi.patch";
      }
      {
        name = "ms-surface/0003-ipts";
        patch = patches + "/5.9/0003-ipts.patch";
      }
      {
        name = "ms-surface/0004-surface-gpe";
        patch = patches + "/5.9/0004-surface-gpe.patch";
      }
      {
        name = "ms-surface/0005-surface-sam-over-hid";
        patch = patches + "/5.9/0005-surface-sam-over-hid.patch";
      }
      {
        name = "ms-surface/0006-surface-sam";
        patch = patches + "/5.9/0006-surface-sam.patch";
      }
      # {
      #   name = "ms-surface/0007-i2c-core-Restore-acpi_walk_dep_device_list-getting-c";
      #   patch = patches + "/5.9/0007-i2c-core-Restore-acpi_walk_dep_device_list-getting-c.patch";
      # }
    ];

    linux_5_10 = [
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
      # {
      #   name = "ms-surface/0002-wifi";
      #   patch = patches + "/5.10/0002-wifi.patch";
      # }
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
      # {
      #   name = "ms-surface/0009-cameras";
      #   patch = patches + "/5.10/0009-cameras.patch";
      # }
    ];
  };
  surface_kernelPackages = {
    linux_5_4_24 = (with pkgs; recurseIntoAttrs (linuxPackagesFor (
      callPackage ./linux-5.4.24.nix {
        kernelPatches = [
          kernelPatches.bridge_stp_helper
          # kernelPatches.request_key_helper
          # kernelPatches.export_kernel_fpu_functions
        ]
        ++ surface_kernelPatches.linux_5_4;
      }
    )));

    linux_5_5_8 = (with pkgs; recurseIntoAttrs (linuxPackagesFor (
      callPackage ./linux-5.5.8.nix {
        kernelPatches = [
          kernelPatches.bridge_stp_helper
          # kernelPatches.request_key_helper
          # kernelPatches.export_kernel_fpu_functions
        ]
        ++ surface_kernelPatches.linux_5_5;
      }
    )));

    linux_5_9_2 = (with pkgs; recurseIntoAttrs (linuxPackagesFor (
      callPackage ./linux-5.9.2.nix {
        kernelPatches = surface_kernelPatches.linux_5_9;
      }
    )));

    linux_5_10_4 = (with pkgs; recurseIntoAttrs (linuxPackagesFor (
      callPackage ./linux-5.10.4.nix {
        kernelPatches = surface_kernelPatches.linux_5_10;
      }
    )));
  };
in {
  surface_kernelPatches = surface_kernelPatches;
  surface_kernelPackages = surface_kernelPackages;
}

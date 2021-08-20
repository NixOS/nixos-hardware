{ config, lib, pkgs, ... }:
let
  repos = (pkgs.callPackage ../../repos.nix { });
  patches = repos.linux-surface + "/patches";
  surface_kernelPatches = [
    {
      name = "microsoft-surface-patches-linux-5.13.4";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
        #
        # Surface Aggregator Module
        #
        SURFACE_AGGREGATOR = module;
        SURFACE_AGGREGATOR_ERROR_INJECTION = no;
        SURFACE_AGGREGATOR_BUS = yes;
        SURFACE_AGGREGATOR_CDEV = module;
        SURFACE_AGGREGATOR_REGISTRY = module;

        SURFACE_ACPI_NOTIFY = module;
        SURFACE_DTX = module;
        SURFACE_PLATFORM_PROFILE = module;

        SURFACE_HID = module;
        SURFACE_KBD = module;

        BATTERY_SURFACE = module;
        CHARGER_SURFACE = module;

        #
        # Surface Hotplug
        #
        SURFACE_HOTPLUG = module;

        #
        # IPTS touchscreen
        #
        # This only enables the user interface for IPTS data.
        # For the touchscreen to work, you need to install iptsd.
        #
        MISC_IPTS = module;

        #
        # Cameras: IPU3
        #
        VIDEO_IPU3_IMGU = module;
        VIDEO_IPU3_CIO2 = module;
        CIO2_BRIDGE = yes;
        INTEL_SKL_INT3472 = module;

        #
        # Cameras: Sensor drivers
        #
        VIDEO_OV5693 = module;
        VIDEO_OV8865 = module;

        #
        # ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
        #
        APDS9960 = module;

        #
        # Other Drivers
        #
        INPUT_SOC_BUTTON_ARRAY = module;
        SURFACE_3_BUTTON = module;
        SURFACE_3_POWER_OPREGION = module;
        SURFACE_PRO3_BUTTON = module;
        SURFACE_GPE = module;
        SURFACE_BOOK1_DGPU_SWITCH = module;
      };
    }
    {
      name = "ms-surface/0001-surface3-oemb";
      patch = patches + "/5.13/0001-surface3-oemb.patch";
    }
    {
      name = "ms-surface/0002-mwifiex";
      patch = patches + "/5.13/0002-mwifiex.patch";
    }
    {
      name = "ms-surface/0003-ath10k";
      patch = patches + "/5.13/0003-ath10k.patch";
    }
    {
      name = "ms-surface/0004-ipts";
      patch = patches + "/5.13/0004-ipts.patch";
    }
    {
      name = "ms-surface/0005-surface-sam-over-hid";
      patch = patches + "/5.13/0005-surface-sam-over-hid.patch";
    }
    {
      name = "ms-surface/0006-surface-sam";
      patch = patches + "/5.13/0006-surface-sam.patch";
    }
    {
      name = "ms-surface/0007-surface-hotplug";
      patch = patches + "/5.13/0007-surface-hotplug.patch";
    }
    {
      name = "ms-surface/0008-surface-typecover";
      patch = patches + "/5.13/0008-surface-typecover.patch";
    }
    {
      name = "ms-surface/0009-cameras";
      patch = patches + "/5.13/0009-cameras.patch";
    }
    {
      name = "ms-surface/0010-amd-gpio";
      patch = patches + "/5.13/0010-amd-gpio.patch";
    }
    {
      name = "ms-surface/0011-amd-s0ix";
      patch = patches + "/5.13/0011-amd-s0ix.patch";
    }
  ];
in (with pkgs;
  recurseIntoAttrs (linuxPackagesFor (callPackage ./linux-5.13.4.nix {
    kernelPatches = surface_kernelPatches;
  })))

{ kernel,
  patchDir,
  version,
}:

[
  {
    name = "microsoft-surface-patches-linux-${version}";
    patch = null;
    structuredExtraConfig = with kernel; {
      #
      # Surface Aggregator Module
      #
      CONFIG_SURFACE_AGGREGATOR = module;
      CONFIG_SURFACE_AGGREGATOR_ERROR_INJECTION = no;
      CONFIG_SURFACE_AGGREGATOR_BUS = yes;
      CONFIG_SURFACE_AGGREGATOR_CDEV = module;
      CONFIG_SURFACE_AGGREGATOR_HUB = module;
      CONFIG_SURFACE_AGGREGATOR_REGISTRY = module;
      CONFIG_SURFACE_AGGREGATOR_TABLET_SWITCH = module;

      CONFIG_SURFACE_ACPI_NOTIFY = module;
      CONFIG_SURFACE_DTX = module;
      CONFIG_SURFACE_PLATFORM_PROFILE = module;

      CONFIG_SURFACE_HID = module;
      CONFIG_SURFACE_KBD = module;

      CONFIG_BATTERY_SURFACE = module;
      CONFIG_CHARGER_SURFACE = module;

      #
      # Surface Hotplug
      #
      CONFIG_SURFACE_HOTPLUG = module;

      #
      # IPTS touchscreen
      #
      # This only enables the user interface for IPTS data.
      # For the touchscreen to work, you need to install iptsd.
      #
      CONFIG_MISC_IPTS = module;

      #
      # Cameras: IPU3
      #
      CONFIG_VIDEO_DW9719 = module;
      CONFIG_VIDEO_IPU3_IMGU = module;
      CONFIG_VIDEO_IPU3_CIO2 = module;
      CONFIG_CIO2_BRIDGE = yes;
      CONFIG_INTEL_SKL_INT3472 = module;
      CONFIG_REGULATOR_TPS68470 = module;
      CONFIG_COMMON_CLK_TPS68470 = module;

      #
      # Cameras: Sensor drivers
      #
      CONFIG_VIDEO_OV5693 = module;
      CONFIG_VIDEO_OV7251 = module;
      CONFIG_VIDEO_OV8865 = module;

      #
      # ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
      #
      CONFIG_APDS9960 = module;

      #
      # Other Drivers
      #
      CONFIG_INPUT_SOC_BUTTON_ARRAY = module;
      CONFIG_SURFACE_3_POWER_OPREGION = module;
      CONFIG_SURFACE_PRO3_BUTTON = module;
      CONFIG_SURFACE_GPE = module;
      CONFIG_SURFACE_BOOK1_DGPU_SWITCH = module;
    };
  }
  {
    name = "ms-surface/0001-surface3-oemb";
    patch = patchDir + "/0001-surface3-oemb.patch";
  }
  {
    name = "ms-surface/0002-mwifiex";
    patch = patchDir + "/0002-mwifiex.patch";
  }
  {
    name = "ms-surface/0003-ath10k";
    patch = patchDir + "/0003-ath10k.patch";
  }
  {
    name = "ms-surface/0004-ipts";
    patch = patchDir + "/0004-ipts.patch";
  }
  {
    name = "ms-surface/0005-surface-sam";
    patch = patchDir + "/0005-surface-sam.patch";
  }
  {
    name = "ms-surface/0006-surface-sam-over-hid";
    patch = patchDir + "/0006-surface-sam-over-hid.patch";
  }
  {
    name = "ms-surface/0007-surface-button";
    patch = patchDir + "/0007-surface-button.patch";
  }
  {
    name = "ms-surface/0008-surface-typecover";
    patch = patchDir + "/0008-surface-typecover.patch";
  }
  {
    name = "ms-surface/0009-cameras";
    patch = patchDir + "/0009-cameras.patch";
  }
  {
    name = "ms-surface/0010-amd-gpio";
    patch = patchDir + "/0010-amd-gpio.patch";
  }
  {
    name = "ms-surface/0011-rtc";
    patch = patchDir + "/0011-rtc.patch";
  }
]

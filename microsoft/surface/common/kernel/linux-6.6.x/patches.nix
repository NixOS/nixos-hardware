{ kernel,
  patchDir,
  version,
}:

[
  {
    name = "microsoft-surface-patches-linux-${version}";
    patch = null;
    extraStructuredConfig = with kernel; {
      STAGING_MEDIA = yes;

      #
      # Surface Aggregator Module
      #
      SURFACE_AGGREGATOR = module;
      SURFACE_AGGREGATOR_ERROR_INJECTION = no;
      SURFACE_AGGREGATOR_BUS = yes;
      SURFACE_AGGREGATOR_CDEV = module;
      SURFACE_AGGREGATOR_HUB = module;
      SURFACE_AGGREGATOR_REGISTRY = module;
      SURFACE_AGGREGATOR_TABLET_SWITCH = module;

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
      # Intel Touch Host Controller
      #
      HID_ITHC = module;

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
      VIDEO_DW9719 = module;
      VIDEO_IPU3_IMGU = module;
      VIDEO_IPU3_CIO2 = module;
      IPU_BRIDGE = module;
      INTEL_SKL_INT3472 = module;
      REGULATOR_TPS68470 = module;
      COMMON_CLK_TPS68470 = module;
      COMMON_LEDS_TPS68470 = module;

      #
      # Cameras: Sensor drivers
      #
      VIDEO_OV5693 = module;
      VIDEO_OV7251 = module;
      VIDEO_OV8865 = module;

      #
      # ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
      #
      APDS9960 = module;

      #
      # Other Drivers
      #
      INPUT_SOC_BUTTON_ARRAY = module;
      SURFACE_3_POWER_OPREGION = module;
      SURFACE_PRO3_BUTTON = module;
      SURFACE_GPE = module;
      SURFACE_BOOK1_DGPU_SWITCH = module;
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
    name = "ms-surface/0005-ithc";
    patch = patchDir + "/0005-ithc.patch";
  }
  {
    name = "ms-surface/0006-surface-sam";
    patch = patchDir + "/0006-surface-sam.patch";
  }
  {
    name = "ms-surface/0007-surface-sam-over-hid";
    patch = patchDir + "/0007-surface-sam-over-hid.patch";
  }
  {
    name = "ms-surface/0008-surface-button";
    patch = patchDir + "/0008-surface-button.patch";
  }
  {
    name = "ms-surface/0009-surface-typecover";
    patch = patchDir + "/0009-surface-typecover.patch";
  }
  {
    name = "ms-surface/0010-surface-shutdown";
    patch = patchDir + "/0010-surface-shutdown.patch";
  }
  {
    name = "ms-surface/0011-surface-gpe";
    patch = patchDir + "/0011-surface-gpe.patch";
  }
  {
    name = "ms-surface/0012-cameras";
    patch = patchDir + "/0012-cameras.patch";
  }
  {
    name = "ms-surface/0013-amd-gpio";
    patch = patchDir + "/0013-amd-gpio.patch";
  }
  {
    name = "ms-surface/0014-rtc";
    patch = patchDir + "/0014-rtc.patch";
  }
]

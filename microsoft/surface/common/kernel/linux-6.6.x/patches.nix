{ lib,
  kernel ? lib.kernel,
  patchSrc,
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
      # SURFACE_AGGREGATOR_ERROR_INJECTION is not set
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

      ##
      ## Surface Hotplug
      ##
      SURFACE_HOTPLUG = module;

      ##
      ## IPTS and ITHC touchscreen
      ##
      ## This only enables the user interface for IPTS/ITHC data.
      ## For the touchscreen to work, you need to install iptsd.
      ##
      HID_IPTS = module;
      HID_ITHC = module;

      ##
      ## Cameras: IPU3
      ##
      VIDEO_DW9719 = module;
      VIDEO_IPU3_IMGU = module;
      VIDEO_IPU3_CIO2 = module;
      IPU_BRIDGE = module;
      INTEL_SKL_INT3472 = module;
      REGULATOR_TPS68470 = module;
      COMMON_CLK_TPS68470 = module;
      LEDS_TPS68470 = module;

      ##
      ## Cameras: Sensor drivers
      ##
      VIDEO_OV5693 = module;
      VIDEO_OV7251 = module;
      VIDEO_OV8865 = module;

      ##
      ## Surface 3: atomisp causes problems (see issue #1095). Disable it for now.
      ##
      # INTEL_ATOMISP is not set

      ##
      ## ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
      ##
      APDS9960 = module;

      ##
      ## Other Drivers
      ##
      INPUT_SOC_BUTTON_ARRAY = module;
      SURFACE_3_POWER_OPREGION = module;
      SURFACE_PRO3_BUTTON = module;
      SURFACE_GPE = module;
      SURFACE_BOOK1_DGPU_SWITCH = module;
    };
  }
  {
    name = "ms-surface/0001-surface3-oemb";
    patch = patchSrc + "/0001-surface3-oemb.patch";
  }
  {
    name = "ms-surface/0002-mwifiex";
    patch = patchSrc + "/0002-mwifiex.patch";
  }
  {
    name = "ms-surface/0003-ath10k";
    patch = patchSrc + "/0003-ath10k.patch";
  }
  {
    name = "ms-surface/0004-ipts";
    patch = patchSrc + "/0004-ipts.patch";
  }
  {
    name = "ms-surface/0005-ithc";
    patch = patchSrc + "/0005-ithc.patch";
  }
  {
    name = "ms-surface/0006-surface-sam";
    patch = patchSrc + "/0006-surface-sam.patch";
  }
  {
    name = "ms-surface/0007-surface-sam-over-hid";
    patch = patchSrc + "/0007-surface-sam-over-hid.patch";
  }
  {
    name = "ms-surface/0008-surface-button";
    patch = patchSrc + "/0008-surface-button.patch";
  }
  {
    name = "ms-surface/0009-surface-typecover";
    patch = patchSrc + "/0009-surface-typecover.patch";
  }
  {
    name = "ms-surface/0010-surface-shutdown";
    patch = patchSrc + "/0010-surface-shutdown.patch";
  }
  {
    name = "ms-surface/0011-surface-gpe";
    patch = patchSrc + "/0011-surface-gpe.patch";
  }
  {
    name = "ms-surface/0012-cameras";
    patch = patchSrc + "/0012-cameras.patch";
  }
  {
    name = "ms-surface/0013-amd-gpio";
    patch = patchSrc + "/0013-amd-gpio.patch";
  }
  {
    name = "ms-surface/0014-rtc";
    patch = patchSrc + "/0014-rtc.patch";
  }
]

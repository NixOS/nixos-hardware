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

##
## Surface Aggregator Module
##
CONFIG_SURFACE_AGGREGATOR= module;
# CONFIG_SURFACE_AGGREGATOR_ERROR_INJECTION is not set
CONFIG_SURFACE_AGGREGATOR_BUS= yes;
CONFIG_SURFACE_AGGREGATOR_CDEV= module;
CONFIG_SURFACE_AGGREGATOR_HUB= module;
CONFIG_SURFACE_AGGREGATOR_REGISTRY= module;
CONFIG_SURFACE_AGGREGATOR_TABLET_SWITCH= module;

CONFIG_SURFACE_ACPI_NOTIFY= module;
CONFIG_SURFACE_DTX= module;
CONFIG_SURFACE_PLATFORM_PROFILE= module;

CONFIG_SURFACE_HID= module;
CONFIG_SURFACE_KBD= module;

CONFIG_BATTERY_SURFACE= module;
CONFIG_CHARGER_SURFACE= module;

CONFIG_SENSORS_SURFACE_TEMP= module;
CONFIG_SENSORS_SURFACE_FAN= module;

##
## Surface Hotplug
##
CONFIG_SURFACE_HOTPLUG= module;

##
## IPTS and ITHC touchscreen
##
## This only enables the user interface for IPTS/ITHC data.
## For the touchscreen to work, you need to install iptsd.
##
CONFIG_HID_IPTS= module;
CONFIG_HID_ITHC= module;

##
## Cameras: IPU3
##
CONFIG_VIDEO_DW9719= module;
CONFIG_VIDEO_IPU3_IMGU= module;
CONFIG_VIDEO_IPU3_CIO2= module;
CONFIG_IPU_BRIDGE= module;
CONFIG_INTEL_SKL_INT3472= module;
CONFIG_REGULATOR_TPS68470= module;
CONFIG_COMMON_CLK_TPS68470= module;
CONFIG_LEDS_TPS68470= module;

##
## Cameras: Sensor drivers
##
CONFIG_VIDEO_OV5693= module;
CONFIG_VIDEO_OV7251= module;
CONFIG_VIDEO_OV8865= module;

##
## Surface 3: atomisp causes problems (see issue #1095). Disable it for now.
##
# CONFIG_INTEL_ATOMISP is not set

##
## ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
##
CONFIG_APDS9960= module;

##
## Build-in UFS support (required for some Surface Go devices)
##
CONFIG_SCSI_UFSHCD= module;
CONFIG_SCSI_UFSHCD_PCI= module;

##
## Other Drivers
##
CONFIG_INPUT_SOC_BUTTON_ARRAY= module;
CONFIG_SURFACE_3_POWER_OPREGION= module;
CONFIG_SURFACE_PRO3_BUTTON= module;
CONFIG_SURFACE_GPE= module;
CONFIG_SURFACE_BOOK1_DGPU_SWITCH= module;
    };
  }
  {
    name = "ms-surface/0001-secureboot";
    patch = patchSrc + "/0001-secureboot.patch";
  }
  {
    name = "ms-surface/0002-surface3-oemb";
    patch = patchSrc + "/0002-surface3-oemb.patch";
  }
  {
    name = "ms-surface/0003-mwifiex";
    patch = patchSrc + "/0003-mwifiex.patch";
  }
  {
    name = "ms-surface/0004-ath10k";
    patch = patchSrc + "/0004-ath10k.patch";
  }
  {
    name = "ms-surface/0005-ipts";
    patch = patchSrc + "/0005-ipts.patch";
  }
  {
    name = "ms-surface/0006-ithc";
    patch = patchSrc + "/0006-ithc.patch";
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

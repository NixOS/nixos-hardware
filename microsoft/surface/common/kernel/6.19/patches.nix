{
  lib,
  kernel ? lib.kernel,
  patchSrc,
  version,
}:

[
  {
    name = "microsoft-surface-patches-linux-${version}";
    patch = null;
    structuredExtraConfig = with kernel; {
      ##
      ## Surface Aggregator Module
      ##
      CONFIG_SURFACE_AGGREGATOR = module;
      # CONFIG_SURFACE_AGGREGATOR_ERROR_INJECTION is not set
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

      CONFIG_SENSORS_SURFACE_TEMP = module;
      CONFIG_SENSORS_SURFACE_FAN = module;

      CONFIG_RTC_DRV_SURFACE = module;

      ##
      ## Surface Hotplug
      ##
      CONFIG_SURFACE_HOTPLUG = module;

      ##
      ## IPTS and ITHC touchscreen
      ##
      ## This only enables the user interface for IPTS/ITHC data.
      ## For the touchscreen to work, you need to install iptsd.
      ##
      CONFIG_HID_IPTS = module;
      CONFIG_HID_ITHC = module;
      CONFIG_INTEL_THC_HID = module;
      CONFIG_INTEL_QUICKSPI = module;

      ##
      ## Cameras: IPU3
      ##
      CONFIG_VIDEO_DW9719 = module;
      CONFIG_VIDEO_IPU3_IMGU = module;
      CONFIG_VIDEO_IPU3_CIO2 = module;
      CONFIG_IPU_BRIDGE = module;
      CONFIG_INTEL_SKL_INT3472 = module;
      CONFIG_REGULATOR_TPS68470 = module;
      CONFIG_COMMON_CLK_TPS68470 = module;
      CONFIG_LEDS_TPS68470 = module;

      ##
      ## Cameras: Sensor drivers
      ##
      CONFIG_VIDEO_OV5693 = module;
      CONFIG_VIDEO_OV7251 = module;
      CONFIG_VIDEO_OV8865 = module;

      ##
      ## Surface 3: atomisp causes problems (see issue #1095). Disable it for now.
      ##
      # CONFIG_INTEL_ATOMISP is not set

      ##
      ## ALS Sensor for Surface Book 3, Surface Laptop 3, Surface Pro 7
      ##
      CONFIG_APDS9960 = module;

      ##
      ## Other Drivers
      ##
      CONFIG_INPUT_SOC_BUTTON_ARRAY = module;
      CONFIG_SURFACE_3_POWER_OPREGION = module;
      CONFIG_SURFACE_PRO3_BUTTON = module;
      CONFIG_SURFACE_GPE = module;
      CONFIG_SURFACE_BOOK1_DGPU_SWITCH = module;
      CONFIG_HID_SURFACE = module;

      ##
      ## HOTFIX FOR CVE-2026-31431
      ##

      # CONFIG_CRYPTO_USER_API_AEAD is not set
    };
  }
  {
    name = "ms-surface/0001-secureboot";
    patch = patchSrc + "/0001-secureboot.patch";
  }
  {
    name = "ms-surface/0002-surface3";
    patch = patchSrc + "/0002-surface3.patch";
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
    name = "ms-surface/0007-surface-sam";
    patch = patchSrc + "/0007-surface-sam.patch";
  }
  {
    name = "ms-surface/0008-surface-sam-over-hid";
    patch = patchSrc + "/0008-surface-sam-over-hid.patch";
  }
  {
    name = "ms-surface/0009-surface-button";
    patch = patchSrc + "/0009-surface-button.patch";
  }
  {
    name = "ms-surface/0010-surface-typecover";
    patch = patchSrc + "/0010-surface-typecover.patch";
  }
  {
    name = "ms-surface/0011-surface-shutdown";
    patch = patchSrc + "/0011-surface-shutdown.patch";
  }
  {
    name = "ms-surface/0012-surface-gpe";
    patch = patchSrc + "/0012-surface-gpe.patch";
  }
  {
    name = "ms-surface/0013-cameras";
    patch = patchSrc + "/0013-cameras.patch";
  }
  {
    name = "ms-surface/0014-amd-gpio";
    patch = patchSrc + "/0014-amd-gpio.patch";
  }
  {
    name = "ms-surface/0015-rtc";
    patch = patchSrc + "/0015-rtc.patch";
  }
  {
    name = "ms-surface/0016-hid-surface";
    patch = patchSrc + "/0016-hid-surface.patch";
  }
  {
    name = "ms-surface/0017-dirtyfrag-xfrm-esp-avoid-in-place-decrypt-on-shared-skb-frags";
    patch = patchSrc + "/0017-dirtyfrag-xfrm-esp-avoid-in-place-decrypt-on-shared-skb-frags.patch";
  }
  {
    name = "ms-surface/0018-dirtyfrag-rxrpc-Fix-potential-UAF-after-skb_unshare-failure";
    patch = patchSrc + "/0018-dirtyfrag-rxrpc-Fix-potential-UAF-after-skb_unshare-failure.patch";
  }
  {
    name = "ms-surface/0019-dirtyfrag-rxrpc-Fix-rxrpc_input_call_event-to-only-unshare-DAT";
    patch = patchSrc + "/0019-dirtyfrag-rxrpc-Fix-rxrpc_input_call_event-to-only-unshare-DAT.patch";
  }
  {
    name = "ms-surface/0020-dirtyfrag-rxrpc-Fix-use-of-wrong-skb-when-comparing-queued-RES";
    patch = patchSrc + "/0020-dirtyfrag-rxrpc-Fix-use-of-wrong-skb-when-comparing-queued-RES.patch";
  }
  {
    name = "ms-surface/0021-dirtyfrag-rxrpc-only-handle-RESPONSE-during-service-challenge";
    patch = patchSrc + "/0021-dirtyfrag-rxrpc-only-handle-RESPONSE-during-service-challenge.patch";
  }
  {
    name = "ms-surface/0022-dirtyfrag-rxrpc-Fix-conn-level-packet-handling-to-unshare-RESP";
    patch = patchSrc + "/0022-dirtyfrag-rxrpc-Fix-conn-level-packet-handling-to-unshare-RESP.patch";
  }
  {
    name = "ms-surface/0023-dirtyfrag-rxrpc-Fix-re-decryption-of-RESPONSE-packets";
    patch = patchSrc + "/0023-dirtyfrag-rxrpc-Fix-re-decryption-of-RESPONSE-packets.patch";
  }
  {
    name = "ms-surface/0024-dirtyfrag-rxrpc-Also-unshare-DATA-RESPONSE-packets-when-paged-";
    patch = patchSrc + "/0024-dirtyfrag-rxrpc-Also-unshare-DATA-RESPONSE-packets-when-paged-.patch";
  }
]

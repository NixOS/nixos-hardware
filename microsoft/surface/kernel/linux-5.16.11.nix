{ lib,
  repos,
}:

let
  inherit (lib) kernel;
  version = "5.16.11";

in {
  inherit version;
  modDirVersion = version;
  branch = "5.16";
  src = repos.linux-surface-kernel {
    # Kernel 5.16.11 from the linux-surface/kernel repo:
    rev = "db94c89f56d6ceae03ca3802e11197f48e6c539f";
    sha256 = "0c58ri0i9gdb4w7l361pnkvq6ap17kmgnxngh0bcdmgn4dc88wx2";
  };
  kernelPatches = [{
    name = "microsoft-surface-patches-linux-${version}";
    patch = null;
    structuredExtraConfig = with kernel; {
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
      # Surface laptop 1 keyboard
      #
      SERIAL_DEV_BUS = yes;
      SERIAL_DEV_CTRL_TTYPORT = yes;

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
  }];
}


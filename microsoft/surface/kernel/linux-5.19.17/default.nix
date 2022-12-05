{ config, lib, pkgs, ... }:

let
  inherit (lib) kernel mkIf mkOption types;
  inherit (pkgs) fetchurl;

  inherit (pkgs.callPackage ../linux-package.nix { }) linuxPackage repos;

  cfg = config.microsoft-surface.kernel-version;

  version = "5.19.17";
  extraMeta.branch = "5.19";
  patches = repos.linux-surface + "/patches/${extraMeta.branch}";

  kernelPackages = linuxPackage {
    inherit version extraMeta;
    # modDirVersion = version;
    src = fetchurl {
      url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
      sha256 = "sha256-yTuzhKl60fCk8Y5ELOApEkJyL3gCPspliyI0RUHwlIk=";
    };

    kernelPatches = [
      {
        name = "microsoft-surface-patches-linux-${version}";
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
      }
      {
        name = "ms-surface/0001-surface3-oemb";
        patch = patches + "/0001-surface3-oemb.patch";
      }
      {
        name = "ms-surface/0002-mwifiex";
        patch = patches + "/0002-mwifiex.patch";
      }
      {
        name = "ms-surface/0003-ath10k";
        patch = patches + "/0003-ath10k.patch";
      }
      {
        name = "ms-surface/0004-ipts";
        patch = patches + "/0004-ipts.patch";
      }
      {
        name = "ms-surface/0005-surface-sam";
        patch = patches + "/0005-surface-sam.patch";
      }
      {
        name = "ms-surface/0006-surface-sam-over-hid";
        patch = patches + "/0006-surface-sam-over-hid.patch";
      }
      {
        name = "ms-surface/0007-surface-button";
        patch = patches + "/0007-surface-button.patch";
      }
      {
        name = "ms-surface/0008-surface-typecover";
        patch = patches + "/0008-surface-typecover.patch";
      }
      {
        name = "ms-surface/0009-surface-gpe";
        patch = patches + "/0009-surface-gpe.patch";
      }
      {
        name = "ms-surface/0010-cameras";
        patch = patches + "/0010-cameras.patch";
      }
      {
        name = "ms-surface/0011-amd-gpio";
        patch = patches + "/0011-amd-gpio.patch";
      }
    ];
  };

in {
  options.microsoft-surface.kernel-version = mkOption {
    type = types.enum [ "5.19.17" ];
  };

  config = mkIf (cfg == "5.19.17") {
    boot = {
      inherit kernelPackages;
    };
  };
}

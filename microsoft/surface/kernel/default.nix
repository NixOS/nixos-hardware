{ config, lib, pkgs, ... }:
let
  kernelVersions = {

        # {
        #   name = "ms-surface/0000-";
        #   patch = ./5.3/0000-.patch;
        # }

    # 19.03 doesn't have these separate versions:
    # TODO: Use explicit Linux versions, instead of leveraging NixOS:

    # linux_5_1 = {
    #   kernelPackages = pkgs.linuxPackages_5_1;
    #   kernelPatches = [
    #     {
    #       name = "ms-surface/0001-surface-acpi";
    #       patch = ./5.1/0001-surface-acpi.patch;
    #     }
    #     {
    #       name = "ms-surface/0002-suspend";
    #       patch = ./5.1/0002-suspend.patch;
    #     }
    #     {
    #       name = "ms-surface/0003-buttons";
    #       patch = ./5.1/0003-buttons.patch;
    #     }
    #     {
    #       name = "ms-surface/0004-cameras";
    #       patch = ./5.1/0004-cameras.patch;
    #     }
    #     {
    #       name = "ms-surface/0005-ipts";
    #       patch = ./5.1/0005-ipts.patch;
    #     }
    #     {
    #       name = "ms-surface/0006-hid";
    #       patch = ./5.1/0006-hid.patch;
    #     }
    #     {
    #       name = "ms-surface/0007-sdcard-reader";
    #       patch = ./5.1/0007-sdcard-reader.patch;
    #     }
    #     {
    #       name = "ms-surface/0008-wifi";
    #       patch = ./5.1/0008-wifi.patch;
    #     }
    #     {
    #       name = "ms-surface/0009-surface3-power";
    #       patch = ./5.1/0009-surface3-power.patch;
    #     }
    #     {
    #       name = "ms-surface/0010-mwlwifi";
    #       patch = ./5.1/0010-mwlwifi.patch;
    #     }
    #     {
    #       name = "ms-surface/0011-surface-lte";
    #       patch = ./5.1/0011-surface-lte.patch;
    #     }
    #   ];
    # };

    # linux_5_2 = {
    #   kernelPackages = pkgs.linuxPackages_5_2;
    #   kernelPatches = [
    #     {
    #       name = "ms-surface/0001-surface-acpi";
    #       patch = ./5.2/0001-surface-acpi.patch;
    #     }
    #     {
    #       name = "ms-surface/0002-suspend";
    #       patch = ./5.2/0002-suspend.patch;
    #     }
    #     {
    #       name = "ms-surface/0003-buttons";
    #       patch = ./5.2/0003-buttons.patch;
    #     }
    #     {
    #       name = "ms-surface/0004-cameras";
    #       patch = ./5.2/0004-cameras.patch;
    #     }
    #     {
    #       name = "ms-surface/0005-ipts";
    #       patch = ./5.2/0005-ipts.patch;
    #     }
    #     {
    #       name = "ms-surface/0006-hid";
    #       patch = ./5.2/0006-hid.patch;
    #     }
    #     {
    #       name = "ms-surface/0007-sdcard-reader";
    #       patch = ./5.2/0007-sdcard-reader.patch;
    #     }
    #     {
    #       name = "ms-surface/0008-wifi";
    #       patch = ./5.2/0008-wifi.patch;
    #     }
    #     {
    #       name = "ms-surface/0009-surface3-power";
    #       patch = ./5.2/0009-surface3-power.patch;
    #     }
    #     {
    #       name = "ms-surface/0010-mwlwifi";
    #       patch = ./5.2/0010-mwlwifi.patch;
    #     }
    #     {
    #       name = "ms-surface/0011-surface-lte";
    #       patch = ./5.2/0011-surface-lte.patch;
    #     }
    #     {
    #       name = "ms-surface/0012-surfacebook2-dgpu";
    #       patch = ./5.2/0012-surfacebook2-dgpu.patch;
    #     }
    #   ];
    # };

    # linux_5_3 = {
    #   kernelPackages = pkgs.linuxPackages_5_3;
    #   kernelPatches = [
    #     {
    #       name = "ms-surface/0001-surface-acpi";
    #       patch = ./5.3/0001-surface-acpi.patch;
    #     }
    #     {
    #       name = "ms-surface/0002-buttons";
    #       patch = ./5.3/0002-buttons.patch;
    #     }
    #     {
    #       name = "ms-surface/0003-hid";
    #       patch = ./5.3/0003-hid.patch;
    #     }
    #     {
    #       name = "ms-surface/0004-surface3-power";
    #       patch = ./5.3/0004-surface3-power.patch;
    #     }
    #     {
    #       name = "ms-surface/0005-surface-lte";
    #       patch = ./5.3/0005-surface-lte.patch;
    #     }
    #     {
    #       name = "ms-surface/0006-wifi";
    #       patch = ./5.3/0006-wifi.patch;
    #     }
    #     {
    #       name = "ms-surface/0007-legacy-i915";
    #       patch = ./5.3/0007-legacy-i915.patch;
    #     }
    #     {
    #       name = "ms-surface/0008-ipts";
    #       patch = ./5.3/0008-ipts.patch;
    #     }
    #     {
    #       name = "ms-surface/0009-ioremap_uc";
    #       patch = ./5.3/0009-ioremap_uc.patch;
    #     }
    #     {
    #       name = "ms-surface/0010-surface3-spi-dma";
    #       patch = ./5.3/0010-surface3-spi-dma.patch;
    #     }
    #   ];
    # };

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
  };
in {
  boot.kernelPackages = kernelVersions.linux_5_4_24.kernelPackages;
  boot.kernelPatches = kernelVersions.linux_5_4_24.kernelPatches;
}

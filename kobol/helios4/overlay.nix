final: prev: {
  linux_5_15_helios4 = final.linux_5_15.override {
    kernelPatches = [
      # A patch to get both PWM fans working
      # the patch has been successfully applied to 5.15 and 5.19
      {
        patch = final.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/03dbd9d3a733f097e23595e76ac60771c655ebf1/patch/kernel/archive/mvebu-5.15/92-mvebu-gpio-remove-hardcoded-timer-assignment.patch";
          sha256 = "sha256-0h7v3Nua1LuHf4h53WdYEBrbUA9dOGdF06TDBlDplOQ=";
        };
      }
      # support for Wake-On-Lan
      {
        patch = final.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/03dbd9d3a733f097e23595e76ac60771c655ebf1/patch/kernel/archive/mvebu-5.15/92-mvebu-gpio-add_wake_on_gpio_support.patch";
          sha256 = "sha256-OrvnVCU55P0U78jdoxGRJvl29i+Rvq8AdEGSCCpxa2I=";
        };
      }
      {
        patch = final.fetchpatch {
          url = "https://raw.githubusercontent.com/armbian/build/03dbd9d3a733f097e23595e76ac60771c655ebf1/patch/kernel/archive/mvebu-5.15/94-helios4-dts-add-wake-on-lan-support.patch";
          sha256 = "sha256-ai4161bTC22023eaVVWsvbk6fQKjkv0P4DQ4DA1Zgow=";
        };
      }

    ];
    defconfig = "mvebu_v7_defconfig";
    # Make the kernel build a bit faster by disabling GPU modules, which we don't need anyways
    structuredExtraConfig = with final.lib.kernel; {
      DRM = no;
    };
  };

  ubootHelios4 = final.buildUBoot rec {
    defconfig = "helios4_defconfig";
    filesToInstall = [ "u-boot-spl.kwb" ];
    # 2021.07 and later are broken, similar to this bug report:
    # https://www.mail-archive.com/u-boot@lists.denx.de/msg451013.html#
    version = "2021.04";
    src = final.fetchFromGitHub {
      owner = "u-boot";
      repo = "u-boot";
      rev = "v${version}";
      sha256 = "sha256-QxrTPcx0n0NWUJ990EuIWyOBtknW/fHDRcrYP0yQzTo=";
    };
    patches = [];
  };
}

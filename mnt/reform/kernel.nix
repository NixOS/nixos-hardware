{
  lib,
  callPackage,
  linuxPackagesFor,
  kernelPatches,
  fetchFromGitLab,
  ...
}:
let
  modDirVersion = "6.16.5";
  reformDebianPackages = fetchFromGitLab {
    domain = "source.mnt.re";
    owner = "reform";
    repo = "reform-debian-packages";
    rev = "830c94db42beef876dc58ea56711659ae7bd415d";
    hash = "sha256-mdORgTOM7RJnEjY5G/iWMHf69wQkql11yRpQ/DrQKb4=";
  };
  linuxPkg =
    {
      lib,
      fetchzip,
      buildLinux,
      callPackage,
      ...
    }@args:
    buildLinux (
      args
      // rec {
        version = "${modDirVersion}-mnt-reform";
        inherit modDirVersion;

        src = fetchzip {
          url = "mirror://kernel/linux/kernel/v${lib.versions.major modDirVersion}.x/linux-${modDirVersion}.tar.xz";
          hash = "sha256-XiTuH40b3VJqzwygZzU0FcvMDj41Rq6IsMbm+3+QxDY=";
        };

        # Use postPatch to apply patches from a directory without IFD
        postPatch = ''
          for patch in ${reformDebianPackages}/linux/patches${lib.versions.majorMinor modDirVersion}/*/*.patch; do
            echo "Applying patch: $patch"
            patch -p1 < "$patch"
          done
        '';

        kernelPatches = [
          {
            name = "reform-dts";
            patch = callPackage ./dtsPatch.nix {
              inherit reformDebianPackages;
              kernelSource = src;
            };
          }
        ];

        structuredExtraConfig = with lib.kernel; {
          # configuration options from https://source.mnt.re/reform/reform-debian-packages/-/blob/7f31ba3a6742d60d8d502c1d86e63ef5df3916bf/linux/config
          DRM_LVDS_CODEC = module;
          DRM_CDNS_MHDP8546 = module;
          DRM_CDNS_HDMI_CEC = module;
          DRM_IMX_CDNS_MHDP = module;
          DRM_IMX_DCSS = module;
          # PHY_FSL_IMX8MQ_HDPTX = module; # configuration option does not exist
          DRM_PANEL_LVDS = module;
          I2C_IMX_LPI2C = module;
          I2C_MUX_REG = module;
          INTERCONNECT_IMX = yes;
          INTERCONNECT_IMX8MQ = yes;
          MFD_WM8994 = module;
          MUX_GPIO = module;
          MUX_MMIO = module;
          RTC_DRV_PCF8523 = module;
          USB_EHCI_FSL = module;
          # NO_HZ_IDLE = yes; # conflicts with NO_HZ_FULL
          SND_SOC_FSL_MICFIL = module;
          SND_IMX_SOC = module;
          SND_SOC_FSL_ASOC_CARD = module;
          SND_SOC_IMX_AUDMIX = module;
          SND_SOC_IMX_HDMI = module;
          INPUT_JOYSTICK = yes;
          JOYSTICK_XPAD = module;
          JOYSTICK_XPAD_FF = yes;
          JOYSTICK_XPAD_LEDS = yes;

          INTERCONNECT_IMX8MP = yes;
          SND_SOC_FSL_ASRC = yes;
          DRM_IMX_LCDIF = yes;
          DRM_IMX8MP_DW_HDMI_BRIDGE = yes;
          DRM_IMX8MP_HDMI_PVI = yes;
          IMX8MM_THERMAL = yes;
          IMX2_WDT = yes;
          DRM_SAMSUNG_DSIM = yes;
          PHY_FSL_SAMSUNG_HDMI_PHY = yes;
          DRM = yes;
          DRM_PANEL_MNT_POCKET_REFORM = module;
          IMX8M_BLK_CTRL = yes;
          IMX_GPCV2_PM_DOMAINS = yes;
          DRM_DISPLAY_CONNECTOR = yes;
          DRM_FSL_LDB = yes;
          BACKLIGHT_CLASS_DEVICE = yes;
          BACKLIGHT_PWM = yes;
          BACKLIGHT_GPIO = yes;
          BACKLIGHT_LED = yes;
          CPU_FREQ_GOV_PERFORMANCE = yes;
          CPU_FREQ_GOV_POWERSAVE = yes;
          CPU_FREQ_GOV_USERSPACE = yes;
          CPU_FREQ_GOV_ONDEMAND = yes;
          CPU_FREQ_GOV_CONSERVATIVE = yes;
          CPU_FREQ_GOV_SCHEDUTIL = yes;
          ARM_IMX_CPUFREQ_DT = yes;
          ARM_IMX_BUS_DEVFREQ = yes;
          IMX_IRQSTEER = yes;

          PCI_MESON = yes;
          DWMAC_MESON = module;
          MDIO_BUS_MUX_MESON_G12A = yes;
          I2C_MESON = yes;
          PWM_MESON = yes;
          USB_DWC3_MESON_G12A = yes;
          MMC_MESON_GX = yes;
          MMC_MESON_MX_SDIO = yes;
          MESON_DDR_PMU = yes;
          RTW88_8822CS = module;

          PWM_FSL_FTM = yes;
          FSL_RCPM = yes;

          ARCH_ROCKCHIP = yes;
          # ARM_ROCKCHIP_CPUFREQ = module; # configuration option does not exist
          DRM_PANTHOR = module;
          NVMEM_ROCKCHIP_OTP = yes;
          PHY_ROCKCHIP_SAMSUNG_HDPTX = module;
          PHY_ROCKCHIP_USBDP = module;
          REGULATOR = yes;
          # ROCKCHIP_REGULATOR_COUPLER = yes; # configuration option does not exist
          SPI_ROCKCHIP = yes;
          SPI_ROCKCHIP_SFC = module;
          ARM_SCMI_CPUFREQ = module;
          VIDEO_ROCKCHIP_VDEC2 = module;
          ROCKCHIP_DW_HDMI_QP = yes;
          ROCKCHIP_DW_MIPI_DSI2 = yes;
          PHY_ROCKCHIP_SAMSUNG_DCPHY = yes;
          REGULATOR_FIXED_VOLTAGE = yes;
          GPIO_ROCKCHIP = yes;
          PL330_DMA = yes;

          DRM_MEGACHIPS_STDPXXXX_GE_B850V3_FW = no; # patches for 6.16 break this driver
        };
      }
      // (args.argsOverride or { })
    );

in
lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))

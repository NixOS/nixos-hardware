{ lib, version }:
with lib.kernel;
with (lib.kernel.whenHelpers version);
{

  ARCH_ROCKCHIP = yes;

  #charger, should always be included
  CHARGER_RK818 = yes;

  #needed for networking via modem as it is connected via usb
  USB_USBNET = module;
  USB_NET_QMI_WWAN = module;

  DRM_ROCKCHIP = yes;

  #gpu
  DRM_PANFROST = module;

  TOUCHSCREEN_GOODIX = module;

  #display
  DRM_PANEL_HIMAX_HX8394 = module;

  #WiFi
  BRCMFMAC = module;

  #bluetooth
  BT_HCIBTSDIO = module;

  #adc
  ROCKCHIP_SARADC = module;

  #IMU (also covers the MPU6500)
  INV_MPU6050_IIO = module;

  #magnetometer
  AF8133J = whenAtLeast "6.9" module;

  #ambient light sensor
  STK3310 = module;

  #cameras
  VIDEO_OV8858 = module;
  VIDEO_IMX258 = module;

  #flash
  LEDS_SGM3140 = module;

  #notification LED
  LEDS_GPIO = module;

  #vibrator
  INPUT_GPIO_VIBRA = module;

  #audio
  SND_SOC_RT5616 = module;
  SND_SOC_RT5640 = module;
  SND_SOC_RK3399_GRU_SOUND = module;
  SND_SOC_ROCKCHIP = module;

  #rk video decoder
  VIDEO_ROCKCHIP_VDEC = module;

  #buttons
  KEYBOARD_ADC = module;

  KEYBOARD_PINEPHONE = module;

  #Uneeded Platforms
  ARCH_ACTIONS = no;
  ARCH_SUNXI = no;
  ARCH_ALPINE = no;
  ARCH_APPLE = no;
  ARCH_BCM = no;
  ARCH_BERLIN = no;
  ARCH_BITMAN = no;
  ARCH_EXYNOS = no;
  ARCH_SPARX5 = no;
  ARCH_K3 = no;
  ARCH_LG1k = no;
  ARCH_HISI = no;
  ARCH_KEEMBAY = no;
  ARCH_MEDIATEK = no;
  ARCH_MESON = no;
  ARCH_MVEBU = no;
  ARCH_NXP = no;
  ARCH_MA35 = no;
  ARCH_NPCM = no;
  ARCH_QCOM = no;
  ARCH_REALTEK = no;
  ARCH_RENESAS = no;
  ARCH_SEATTLE = no;
  ARCH_SOCFPGA = no;
  ARCH_STM32 = no;
  ARCH_SYNQUACER = no;
  ARCH_TEGRA = no;
  ARCH_SPRD = no;
  ARCH_THUNDER = no;
  ARCH_THUNDER2 = no;
  ARCH_UNIPHIER = no;
  ARCH_VEXPRESS = no;
  ARCH_VISCONTI = no;
  ARCH_XGENE = no;
  ARCH_ZYNQMP = no;

  #Modules that are probably not needed by anyone
  DRM_NOUVEAU = no;
  DRM_AMDGPU = no;

  #pahole causes OOM(6GiB> including zram) during build, disabling it as a mitigation
  CONFIG_BPF = lib.mkForce no;
  BPF_SYSCALL = lib.mkForce no;
  BPF_JIT = lib.mkForce no;
  BPF_JIT_ALWAYS_ON = lib.mkForce no;
  BPF_JIT_DEFAULT_ON = lib.mkForce no;
  PAHOLE_HAS_BTF_TAG = lib.mkForce no;
  DEBUG_INFO_BTF = lib.mkForce no;
  DEBUG_INFO_BTF_MODULES = lib.mkForce no;

}

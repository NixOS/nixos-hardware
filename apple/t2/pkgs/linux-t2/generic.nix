{
  lib,
  fetchurl, # fetchpatch does unnecessary normalization
  ...
}@args:

{
  kernel,
  patchesFile,
}:
let
  inherit (builtins) readFile fromJSON;

  patchset = fromJSON (readFile patchesFile);
  t2-patches = map (
    { name, hash }:
    {
      inherit name;
      patch = fetchurl {
        inherit name hash;
        url = patchset.base_url + name;
      };
    }
  ) patchset.patches;
in
kernel.override (
  args
  // {
    pname = "linux-t2";

    structuredExtraConfig = with lib.kernel; {
      T2BCE_CORE = module;
      T2BCE_VHCI = module;
      T2BCE_AUDIO = module;
      T2BCE_AVE = module;
      APPLE_GMUX = module;
      APFS_FS = module;
      BRCMFMAC = module;
      BT_BCM = module;
      BT_HCIBCM4377 = module;
      BT_HCIUART = module;
      BT_HCIUART_BCM = yes;
      DRM_APPLETBDRM = module;
      HID_APPLE = module;
      HID_APPLETB_BL = module;
      HID_APPLETB_KBD = module;
      HID_MAGICMOUSE = module;
      HID_SENSOR_ALS = module;
      SENSORS_APPLESMC = module;
      SND_PCM = module;
      STAGING = yes;

      # required for t2bce_ave
      I2C = yes;
      MEDIA_SUPPORT = yes;
      MEDIA_CAMERA_SUPPORT = yes;
      MEDIA_ANALOG_TV_SUPPORT = yes;
      MEDIA_DIGITAL_TV_SUPPORT = yes;
      MEDIA_RADIO_SUPPORT = yes;
      MEDIA_SDR_SUPPORT = yes;
      MEDIA_PLATFORM_SUPPORT = yes;
      MEDIA_TEST_SUPPORT = yes;
    };

    kernelPatches = t2-patches ++ (args.kernelPatches or [ ]);

    argsOverride.extraMeta = {
      description = "The Linux kernel (with patches from the T2 Linux project)";

      # take responsibility for the downstream kernel
      maintainers = with lib.maintainers; [ soopyc ];
    };
  }
  // (args.argsOverride or { })
)

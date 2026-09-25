{
  lib,
  fetchurl, # fetchpatch does unnecessary normalization
  buildLinux,
  linuxKernel,
  ...
}@args:

patchesFile:

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
buildLinux (
  {
    pname = "linux-t2";
    version = patchset.kernel.version;

    src = fetchurl {
      inherit (patchset.kernel) url hash;
    };

    structuredExtraConfig = with lib.kernel; {
      APPLE_BCE = module;
      APPLE_GMUX = module;
      APFS_FS = module;
      BRCMFMAC = module;
      BT_BCM = module;
      BT_HCIBCM4377 = module;
      BT_HCIUART_BCM = yes;
      BT_HCIUART = module;
      HID_APPLETB_BL = module;
      HID_APPLETB_KBD = module;
      HID_APPLE = module;
      HID_MAGICMOUSE = module;
      DRM_APPLETBDRM = module;
      HID_SENSOR_ALS = module;
      SND_PCM = module;
      STAGING = yes;
    };

    kernelPatches = [
      # include default patches for good measure
      linuxKernel.kernelPatches.request_key_helper
      linuxKernel.kernelPatches.bridge_stp_helper
    ]
    ++ t2-patches
    ++ (args.kernelPatches or [ ]);

    extraMeta = {
      description = "The Linux kernel (with patches from the T2 Linux project)";

      # take responsibility for the downstream kernel
      maintainers = with lib.maintainers; [ soopyc ];
    };
  }
  // (args.argsOverride or { })
)

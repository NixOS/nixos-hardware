{ lib, buildLinux, fetchFromGitHub, fetchzip, runCommand
, ... } @ args:

let
  version = "6.12.4";
  majorVersion = lib.elemAt (lib.take 1 (lib.splitVersion version)) 0;

  patchRepo = fetchFromGitHub {
    owner = "t2linux";
    repo = "linux-t2-patches";
    rev = "539eea1f9127f1623794ee8c7ccc37e8b00f60a3";
    hash = "sha256-pFeNOLTqnEupyEZDk+fX/5GFpobvN+L7Wv2K6V5Xx9g=";
  };

  kernel = fetchzip {
    url = "mirror://kernel/linux/kernel/v${majorVersion}.x/linux-${version}.tar.xz";
    hash = "sha256-SiQzaqraT/5s6Mown8/DeOWU7VR3IG0ojvkqThO09+0=";
  };
in
buildLinux (args // {
  inherit version;

  pname = "linux-t2";
  # Snippet from nixpkgs
  modDirVersion = "${lib.concatStringsSep "." (lib.take 3 (lib.splitVersion "${version}.0"))}";

  src = runCommand "patched-source" {} ''
    cp -r ${kernel} $out
    chmod -R u+w $out
    cd $out
    while read -r patch; do
      echo "Applying patch $patch";
      patch -p1 < $patch;
    done < <(find ${patchRepo} -type f -name "*.patch" | sort)
  '';

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
    DRM_APPLETBDRM = module;
    HID_SENSOR_ALS = module;
    SND_PCM = module;
    STAGING = yes;
  };

  kernelPatches = [];
} // (args.argsOverride or {}))

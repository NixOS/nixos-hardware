{ lib, buildLinux, fetchFromGitHub, fetchzip, runCommand
, ... } @ args:

let
  version = "6.9.8";
  majorVersion = with lib; (elemAt (take 1 (splitVersion version)) 0);

  patchRepo = fetchFromGitHub {
    owner = "t2linux";
    repo = "linux-t2-patches";
    rev = "47b4069221c0ee3b6db56ab1ea90ae89e2de26f3";
    hash = "sha256-1B5DbLdyKdswy2ERmWVyjojdazTDbMsS+Vz/mrTdoFY=";
  };

  kernel = fetchzip {
    url = "mirror://kernel/linux/kernel/v${majorVersion}.x/linux-${version}.tar.xz";
    hash = "sha256-o67tasZu4qGQ7obw+BCgNfaLqDcT3SPqsa3kTzWjmfg=";
  };
in
buildLinux (args // {
  inherit version;

  pname = "linux-t2";
  # Snippet from nixpkgs
  modDirVersion = with lib; "${concatStringsSep "." (take 3 (splitVersion "${version}.0"))}";

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

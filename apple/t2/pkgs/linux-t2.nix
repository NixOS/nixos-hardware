{ lib, buildLinux, fetchFromGitHub, fetchurl, ... } @ args:

let
  patchRepo = fetchFromGitHub {
    owner = "t2linux";
    repo = "linux-t2-patches";
    rev = "c908e506346681139a844d41c40b295cfad17ea8";
    hash = "sha256-zCpZP/QrnP4xB2bJ0yZv88N4BgE4K+5KOCzm/pBbnJw=";
  };

  version = "6.4.9";
  majorVersion = with lib; (elemAt (take 1 (splitVersion version)) 0);
in
buildLinux (args // {
  inherit version;

  pname = "linux-t2";
  # Snippet from nixpkgs
  modDirVersion = with lib; "${concatStringsSep "." (take 3 (splitVersion "${version}.0"))}";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${majorVersion}.x/linux-${version}.tar.xz";
    hash = "sha256-uLiimFK5mfM3xOk+/2yR+3/S1JpmFMvL62+hcbpVzJ8=";
  };

  structuredExtraConfig = with lib.kernel; {
    APPLE_BCE = module;
    APPLE_GMUX = module;
    BRCMFMAC = module;
    BT_BCM = module;
    BT_HCIBCM4377 = module;
    BT_HCIUART_BCM = yes;
    BT_HCIUART = module;
    HID_APPLE_IBRIDGE = module;
    HID_APPLE = module;
    HID_APPLE_MAGIC_BACKLIGHT = module;
    HID_APPLE_TOUCHBAR = module;
    HID_SENSOR_ALS = module;
    SND_PCM = module;
    STAGING = yes;
  };

  kernelPatches = lib.attrsets.mapAttrsToList (file: type: { name = file; patch = "${patchRepo}/${file}"; })
    (lib.attrsets.filterAttrs (file: type: type == "regular" && lib.strings.hasSuffix ".patch" file)
      (builtins.readDir patchRepo));
} // (args.argsOverride or {}))

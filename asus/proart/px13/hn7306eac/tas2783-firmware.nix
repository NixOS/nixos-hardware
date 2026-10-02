{
  lib,
  stdenvNoCC,
  fetchurl,
  icoutils,
  p7zip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "asus-px13-tas2783-firmware";
  version = "6.3.1.15";

  src = fetchurl {
    url = "https://dlcdnets.asus.com/pub/ASUS/nb/Image/Driver/Audio/47519/SmartAMP_TI_DCH_TexasInstruments_Z_V${finalAttrs.version}_47519.exe?model=HN7306EAC";
    hash = "sha256-hyiDV5W+Rn05xyG2JF5uA41E/L8NDklxjvRctE64o84=";
  };

  nativeBuildInputs = [
    icoutils
    p7zip
  ];

  unpackPhase = ''
    wrestool -x --raw -t ZIP -n 103 "$src" > driver.7z 2>/dev/null
    7z x driver.7z -ozip_out -y >/dev/null 2>&1
  '';

  installPhase = ''
    install -D -m 644 $(find zip_out -name "1714-1-0x8.bin" | head -1) $out/lib/firmware/1714-1-0x8.bin
    install -D -m 644 $(find zip_out -name "1714-1-0xB.bin" | head -1) $out/lib/firmware/1714-1-0xB.bin
  '';

  meta = {
    description = "TAS2783 Smart Amp firmware for ASUS ProArt PX13 HN7306EAC";
    homepage = "https://www.asus.com/support/download/HN7306EAC/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [ unfreeRedistributableFirmware ];
    platforms = [ "x86_64-linux" ];
  };
})

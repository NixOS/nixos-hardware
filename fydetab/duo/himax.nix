{
  stdenv,
  fetchurl,
  lib,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "himax-firmware";
  version = "2024-11-09";

  src = fetchurl {
    url = "https://github.com/Linux-for-Fydetab-Duo/pkgbuilds/raw/f4c012bd42d87f677370f987f703982d53cd233d/fydetabduo-post-install/Himax_firmware.bin";
    hash = "sha256-z0p/zXcNTBdhKCV6GmM2C8C02lu4Wkb2HP+Ir/nQJTc=";
  };

  compressFirmware = false;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware
    cp --no-preserve=ownership,mode $src $out/lib/firmware/Himax_firmware.bin
    ls -ahl $out/lib/firmware

    runHook postInstall
  '';

  meta = {
    description = "Himax sensor firmware";
    license = lib.licenses.unfree;
  };
})

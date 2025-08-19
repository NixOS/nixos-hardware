{
  stdenv,
  fetchurl,
  lib,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "mali-g610-firmware";
  version = "2024-08-23";

  src = fetchurl {
    url = "https://github.com/Linux-for-Fydetab-Duo/pkgbuilds/raw/refs/heads/main/mali-G610-firmware-rkr4/mali_csffw.bin";
    hash = "sha256-Ei8ezBTS3g/pP8Al+Md+RTGr0AT6Fy/+aeQM19FdXGY=";
  };

  compressFirmware = false;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware
    cp --no-preserve=ownership,mode $src $out/lib/firmware/mali_csffw.bin
    ls -ahl $out/lib/firmware

    runHook postInstall
  '';

  meta = {
    description = "Mali G610 firmware for Rockchip RK3588(S) using the rkr4 kernel or later";
    license = lib.licenses.unfree;
  };
})

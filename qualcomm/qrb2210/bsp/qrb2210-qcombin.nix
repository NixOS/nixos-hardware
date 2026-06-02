{
  fetchurl,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "qrb2210-qcombin";
  version = "2026-04-02";

  src = fetchurl {
    url = "https://github.com/armbian/qcombin/archive/537da4bb0d4d4ea23299ac596fa6c9f099c51ecd.tar.gz";
    hash = "sha256-v/58H9ThIFOmFcGjEg4IuFllDJBNCNGRzfDb6FDRZ6s=";
  };

  installPhase = ''
    runHook preInstall

    install -d $out/share/qcombin
    cp -r Agatti $out/share/qcombin/

    runHook postInstall
  '';

  meta = {
    description = "Qualcomm EDL flash binaries for Arduino UNO Q";
    # Data-only; copied into images from x86_64 builders too.
    platforms = lib.platforms.all;
  };
}


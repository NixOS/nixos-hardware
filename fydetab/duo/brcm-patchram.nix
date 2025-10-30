{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "brcm-patchram-plus";
  version = "2024-08-23";

  src = fetchurl {
    url = "https://github.com/Linux-for-Fydetab-Duo/pkgbuilds/raw/fd5ebe4914f32c5a1c4fc15b4fb5a62bad2da1ea/fydetabduo-post-install/brcm_patchram_plus";
    hash = "sha256-fZ1ximZcosZDYbveEkyMnasLWpcifaZ5CKz7QKtqKZQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  unpackPhase = ''
    runHook preUnpack
    cp --no-preserve=ownership,mode $src brcm_patchram_plus
    chmod +x brcm_patchram_plus
    runHook postUnpack
  '';

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp brcm_patchram_plus $out/bin
    autoPatchelf $out/bin/brcm_patchram_plus

    runHook postInstall
  '';

  meta = {
    license = lib.licenses.unfree;
    mainProgram = "brcm_patchram_plus";
  };
})

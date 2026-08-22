{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  expat,
  zlib,
}:

# IPU7 firmware and proprietary AIQ image-processing libraries (auto white
# balance, auto exposure, per-sensor colour tuning). These blobs are what make
# the hardware ISP produce correctly coloured images — the free software ISP
# in libcamera has no tuning for the OV08F4/OV08X40 sensor.
#
# Vendored from nixpkgs PR #542085; drop once that merges and use
# pkgs.ipu7-camera-bins instead. Unfree (Intel Simplified Software License):
# users must allow it — see README.md.
stdenv.mkDerivation (finalAttrs: {
  pname = "ipu7-camera-bins";
  version = "20260629_1";

  src = fetchFromGitHub {
    repo = "ipu7-camera-bins";
    owner = "intel";
    rev = finalAttrs.version;
    hash = "sha256-LjiqxlQKDLArgK2puxlyTpLPtL6QN6P/xWO2asPTLig=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    expat
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp --no-preserve=mode --recursive \
      lib \
      include \
      $out/

    runHook postInstall
  '';

  postFixup = ''
    for lib in $out/lib/lib*${stdenv.hostPlatform.extensions.sharedLibrary}*; do
      lib=''${lib##*/}
      target=$out/lib/''${lib%.*}
      if [ ! -e "$target" ]; then
        ln -s "$lib" "$target"
      fi
    done

    for pcfile in $out/lib/pkgconfig/*.pc; do
      substituteInPlace $pcfile \
        --replace-quiet 'prefix=/usr' "prefix=$out"
    done
  '';

  meta = {
    description = "IPU firmware and proprietary image processing libraries";
    homepage = "https://github.com/intel/ipu7-camera-bins";
    license = lib.licenses.issl;
    sourceProvenance = with lib.sourceTypes; [
      binaryFirmware
    ];
    platforms = [ "x86_64-linux" ];
  };
})

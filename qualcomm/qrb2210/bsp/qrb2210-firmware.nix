{
  fetchurl,
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "qrb2210-firmware";
  version = "2026-05-08";

  # Upstream qcom firmware tree ships relative symlinks to blobs we do not install.
  dontCheckForBrokenSymlinks = true;

  src = fetchurl {
    url = "https://github.com/armbian/firmware/archive/1d1d4ac234c23ea7d7dc85a001492f7e0e765f80.tar.gz";
    hash = "sha256-GiNJfFG21oduYGoshsOuJ/Wn+XOCxmw3cjG0i1nndi8=";
  };

  installPhase = ''
    runHook preInstall

    if [ -d firmware ]; then
      firmware_dir=firmware
    elif [ -d packages/blobs/arduino/firmware ]; then
      firmware_dir=packages/blobs/arduino/firmware
    else
      firmware_dir=.
    fi

    install -d $out/lib/firmware
    cp -r "$firmware_dir"/ath10k $out/lib/firmware/
    cp -r "$firmware_dir"/qca $out/lib/firmware/
    cp -r "$firmware_dir"/qcom $out/lib/firmware/

    # Strip dangling symlinks: NixOS recompresses firmware as *-zstd and that step
    # runs a symlink check ignoring dontCheckForBrokenSymlinks here.
    find "$out/lib/firmware" -type l ! -exec test -e {} \; -delete

    runHook postInstall
  '';

  meta = {
    description = "Firmware blobs for Qualcomm QRB2210/QCM2290 boards";
    # Runs on aarch64 boards; unpacking is portable so builds can happen on other systems (e.g. cross from x86_64).
    platforms = lib.platforms.all;
  };
}

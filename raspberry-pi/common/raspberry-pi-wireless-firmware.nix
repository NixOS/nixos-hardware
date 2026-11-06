{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "raspberrypi-wireless-firmware";
  version = "0-unstable-2026-07-10";

  srcs = [
    (fetchFromGitHub {
      name = "bluez-firmware";
      owner = "RPi-Distro";
      repo = "bluez-firmware";
      rev = "cdf61dc691a49ff01a124752bd04194907f0f9cd";
      hash = "sha256-35pnbQV/zcikz9Vic+2a1QAS72riruKklV8JHboL9NY=";
    })
    (fetchFromGitHub {
      name = "firmware-nonfree";
      owner = "RPi-Distro";
      repo = "firmware-nonfree";
      rev = "3bab0f823f5b53150b76aab77093adef6655b920";
      hash = "sha256-2DXj2esIix8YQwBf3IuzHwnUJ+yCANbRdpyS/DeB4XE=";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;
  # Firmware blobs do not need fixing and should not be modified
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/firmware/brcm"

    # Wifi firmware
    cp -r "firmware-nonfree/debian/added-firmware/brcm" "$out/lib/firmware/"
    cp -r "firmware-nonfree/debian/added-firmware/cypress" "$out/lib/firmware/"

    # Bluetooth firmware
    cp -r "bluez-firmware/debian/firmware/broadcom/." "$out/lib/firmware/brcm"

    # The brcmfmac43455-sdio.raspberrypi,*.bin board firmwares (Pi 3A+/3B+/CM4/4B/500/CM5/5B)
    # symlink to ../cypress/cyfmac43455-sdio.bin, which RPi-Distro ships only as the
    # cyfmac43455-sdio-standard.bin variant. Create the missing target so they resolve.
    # See https://github.com/RPi-Distro/firmware-nonfree/issues/26
    ln -s "./cyfmac43455-sdio-standard.bin" "$out/lib/firmware/cypress/cyfmac43455-sdio.bin"

    runHook postInstall
  '';

  meta = {
    description = "Firmware for builtin Wifi/Bluetooth devices in the Raspberry Pi 3+ and Zero W";
    homepage = "https://github.com/RPi-Distro/firmware-nonfree";
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with lib.maintainers; [ lopsided98 ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
  };
}

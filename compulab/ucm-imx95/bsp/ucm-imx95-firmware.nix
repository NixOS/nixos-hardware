{
  stdenv,
  fetchurl,
  coreutils,
  bash,
  siliconRev ? "A0",
  ...
}:

stdenv.mkDerivation rec {
  pname = "nxp-firmware-imx95";
  version = "nxp-firmware-8.28-994fa14";

  m7Firmware = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/imx95-m7-demo-25.09.00.bin";
    sha256 = "sha256-3nA6uka6WPtXH5aZhaaKHKRM0tJ0pxHQdPEupNic1Ks=";
  };

  ddrFirmware = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-8.28-994fa14.bin";
    sha256 = "sha256-VZlvNA6HglaFoAzTCZARiQZuyVRe5gdzT5QsPN5Nadw=";
  };

  ahabFirmware = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-ele-imx-2.0.2-89161a8.bin";
    sha256 = "sha256-LSnwpN42YroV9qfZBpcC1OrtQV2WoX8p1bEn8sb91jQ=";
  };

  nativeBuildInputs = [
    coreutils
    bash
  ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    export SILICON=${siliconRev}

    # M7 firmware
    echo "Copying M7 firmware..."
    cp ${m7Firmware} $out/m7_image.bin

    # DDR firmware
    cp ${ddrFirmware} ./firmware-imx-8.28-994fa14.bin
    chmod +x firmware-imx-8.28-994fa14.bin
    ./firmware-imx-8.28-994fa14.bin --auto-accept

    mkdir -p $out/ddr
    # Resolve wildcard and verify at least one file matches
    lpddr5_files=(firmware-imx-8.28-994fa14/firmware/ddr/synopsys/lpddr5*v202409.bin)
    if [ ''${#lpddr5_files[@]} -eq 0 ]; then
      echo "ERROR: No lpddr5*v202409.bin file found in firmware/ddr/synopsys/" >&2
      exit 1
    fi
    cp "''${lpddr5_files[@]}" $out/ddr/

    # AHAB container
    cp ${ahabFirmware} ./firmware-ele-imx-2.0.2-89161a8.bin
    chmod +x firmware-ele-imx-2.0.2-89161a8.bin
    ./firmware-ele-imx-2.0.2-89161a8.bin --auto-accept

    mkdir -p $out/ahab
    if [ "$SILICON" = "A0" ]; then
      cp firmware-ele-imx-2.0.2-89161a8/mx95a0-ahab-container.img $out/ahab/
    elif [ "$SILICON" = "B0" ]; then
      cp firmware-ele-imx-2.0.2-89161a8/mx95b0-ahab-container.img $out/ahab/
    else
      echo "ERROR: Invalid SILICON value '$SILICON'. Must be 'A0' or 'B0'." >&2
      exit 1
    fi
  '';
}

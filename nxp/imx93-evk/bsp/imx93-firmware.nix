{ pkgs, ... }:

with pkgs;
stdenv.mkDerivation rec {
  pname = "nxp-firmware";
  version = "nxp-firmware-8.21-0.11";

  ddrFirmware = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-8.21.bin";
    sha256 = "sha256-w0R/D4E0FczqncLvEggMs6yLvAxnOSp0/H1ZIF61pnI=";
  };

  ahabFirmware = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-sentinel-0.11.bin";
    sha256 = "sha256-JpSAQXqK6apMxBAauUcof8M0VakxAh29xNm621ISvOs=";
  };

  nativeBuildInputs = [
    coreutils
    bash
  ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out

    echo "Extracting DDR firmware..."
    cp ${ddrFirmware} ./firmware-imx-8.21.bin
    chmod +x firmware-imx-8.21.bin
    ./firmware-imx-8.21.bin --auto-accept

    echo "Extracting AHAB firmware..."
    cp ${ahabFirmware} ./firmware-sentinel-0.11.bin
    chmod +x firmware-sentinel-0.11.bin
    ./firmware-sentinel-0.11.bin --auto-accept

    echo "Copying DDR .bin files..."
    mkdir -p $out/ddr
    cp firmware-imx-8.21/firmware/ddr/synopsys/lpddr4*.bin $out/ddr/

    echo "Copying AHAB container image..."
    mkdir -p $out/ahab
    cp firmware-sentinel-0.11/mx93a1-ahab-container.img $out/ahab/

  '';
}

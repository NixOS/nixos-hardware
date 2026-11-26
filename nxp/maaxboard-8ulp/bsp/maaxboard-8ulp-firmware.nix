{ pkgs }:

with pkgs;
let
  maaxboard-8ulp-m33 = callPackage ./maaxboard-8ulp-m33.nix { };

  # maaxboard-build-tools export_fmver() for BSP lf-6.1.22-2.0.0 (6.1.22).
  sentinelInstaller = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-sentinel-0.10.bin";
    sha256 = "sha256-voYrYshJUQzOCOwkwd31PYJkWOMm5afwnEs1CS1vmVA=";
  };

  upowerInstaller = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-upower-1.3.0.bin";
    sha256 = "sha256-9ScVEiRfuhlTb9CW7FR+TntVjlCfaZQQD9cBpi4zWI8=";
  };
in
stdenv.mkDerivation {
  pname = "maaxboard-8ulp-firmware";
  version = "lf-6.1.22-2.0.0";

  nativeBuildInputs = [
    coreutils
    bash
  ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out

    cp ${maaxboard-8ulp-m33}/m33_image.bin $out/m33_image.bin

    cp ${sentinelInstaller} ./firmware-sentinel-0.10.bin
    chmod +x firmware-sentinel-0.10.bin
    ./firmware-sentinel-0.10.bin --auto-accept
    cp firmware-sentinel-0.10/mx8ulpa2-ahab-container.img $out/

    cp ${upowerInstaller} ./firmware-upower-1.3.0.bin
    chmod +x firmware-upower-1.3.0.bin
    ./firmware-upower-1.3.0.bin --auto-accept

    # A2 silicon uses upower_a1 (maaxboard-build-tools bootloader/build.sh, REV=A2).
    if [ -f firmware-upower-1.3.0/upower_a1.bin ]; then
      cp firmware-upower-1.3.0/upower_a1.bin $out/upower.bin
    elif [ -f firmware-upower-1.3.0/upower_a0.bin ]; then
      cp firmware-upower-1.3.0/upower_a0.bin $out/upower.bin
    else
      echo "No upower firmware found in installer" >&2
      exit 1
    fi
  '';

  meta = with lib; {
    homepage = "https://github.com/Avnet/maaxboard-build-tools";
    description = "MaaXBoard 8ULP boot firmware (sentinel A2 AHAB + upower + M33 from mcore_sdk_8ulp)";
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };
}

{ pkgs, fetchgit }:

with pkgs;
let
  # https://github.com/Avnet/meta-maaxboard/tree/langdale/recipes-bsp/imx-mkimage/imx-boot
  metaMaaxboard = fetchgit {
    url = "https://github.com/Avnet/meta-maaxboard.git";
    rev = "cab913d1d7afbae060b0c7bf5d92831c441939a6";
    sha256 = "sha256-Htxa7xcaNTBJIlZSps46BYNMvj4G/0uUvKcQD3/z8T0=";
    sparseCheckout = [ "recipes-bsp/imx-mkimage/imx-boot" ];
  };

  imxBoot = "${metaMaaxboard}/recipes-bsp/imx-mkimage/imx-boot";

  upowerInstaller = fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-upower-1.3.1.bin";
    sha256 = "sha256-HfOgPWn+s4pFDuY6vHcT14z2M5mIR25Mn5Xrv2N5D2Y=";
  };
in
stdenv.mkDerivation {
  pname = "maaxboard-8ulp-firmware";
  version = "meta-maaxboard-langdale";

  nativeBuildInputs = [
    coreutils
    bash
  ];

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out

    cp ${imxBoot}/mx8ulpa0-ahab-container.img $out/
    cp ${imxBoot}/maaxboard_8ulp_m33_image.bin $out/m33_image.bin

    cp ${upowerInstaller} ./firmware-upower-1.3.1.bin
    chmod +x firmware-upower-1.3.1.bin
    ./firmware-upower-1.3.1.bin --auto-accept

    if [ -f firmware-upower-1.3.1/upower_a0.bin ]; then
      cp firmware-upower-1.3.1/upower_a0.bin $out/upower.bin
    elif [ -f firmware-upower-1.3.1/upower_a1.bin ]; then
      cp firmware-upower-1.3.1/upower_a1.bin $out/upower.bin
    else
      echo "No upower firmware found in installer" >&2
      exit 1
    fi
  '';

  meta = with lib; {
    homepage = "https://github.com/Avnet/meta-maaxboard/tree/langdale/recipes-bsp/imx-mkimage/imx-boot";
    description = "MaaXBoard 8ULP boot firmware (Avnet meta-maaxboard imx-boot + meta-imx firmware-upower)";
  };
}

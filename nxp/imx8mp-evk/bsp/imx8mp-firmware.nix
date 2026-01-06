{ pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "imx8mp-firmware";
  version = "8.23";

  src = pkgs.fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-${version}.bin";
    sha256 = "sha256-/gdjMpXaw92Z8LpOB6fN6VuySinKgrmps/YCbSmukWo=";
  };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    ${pkgs.buildPackages.bash}/bin/bash $src --auto-accept --force
    mv firmware-imx-${version} $out
  '';
}

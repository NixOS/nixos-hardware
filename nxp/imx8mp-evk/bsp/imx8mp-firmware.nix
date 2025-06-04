{ pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "imx8mp-firmware";
  version = "8.22";

  src = pkgs.fetchurl {
    url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/firmware-imx-${version}.bin";
    sha256 = "sha256-lMi86sVuxQPCMuYU931rvY4Xx9qnHU5lHqj9UDTDA1A=";
  };

  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    ${pkgs.bash}/bin/bash $src --auto-accept --force
    mv firmware-imx-${version} $out
  '';
}

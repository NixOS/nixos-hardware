{
  lib,
  fetchgit,
  stdenv,
  buildPackages,
  pkgsCross,
  openssl,
}:

let
  target-board = "imx8ulp";
in
stdenv.mkDerivation rec {
  pname = "maaxboard-8ulp-atf";
  version = "2.8";
  platform = target-board;
  enableParallelBuilding = true;

  src = fetchgit {
    url = "https://github.com/Avnet/imx-atf.git";
    rev = "f79eb120d7b08ee02b935b47e934b9ce232cb603";
    sha256 = "sha256-r7c42GaOU+NHN24681KeS07py+QyIFAG/6tE9syYemA=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkgsCross.aarch64-embedded.stdenv.cc ];

  buildInputs = [ openssl ];

  makeFlags = [
    "HOSTCC=$(CC_FOR_BUILD)"
    "CROSS_COMPILE=${pkgsCross.aarch64-embedded.stdenv.cc.targetPrefix}"
    "PLAT=${platform}"
    "bl31"
    "LDFLAGS=-no-warn-rwx-segments"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp build/${target-board}/release/bl31.bin $out
    runHook postInstall
  '';

  hardeningDisable = [ "all" ];
  dontStrip = true;

  meta = with lib; {
    homepage = "https://github.com/Avnet/imx-atf";
    description = "ARM Trusted Firmware for Avnet MaaXBoard 8ULP (i.MX8ULP)";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };
}

{
  lib,
  fetchgit,
  stdenv,
  buildPackages,
  pkgsCross,
  openssl,
}:

let
  target-board = "imx93";
in
stdenv.mkDerivation rec {
  pname = "imx93-atf";
  version = "2.10.0";
  platform = target-board;
  enableParallelBuilding = true;

  src = fetchgit {
    url = "https://github.com/nxp-imx/imx-atf.git";
    rev = "28affcae957cb8194917b5246276630f9e6343e1";
    sha256 = "sha256-a8F+Lf8pwML+tCwawS0N/mrSXWPmFhlUeOg0MCRK3VE=";
  };

  # Compiler dependencies
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ pkgsCross.aarch64-embedded.stdenv.cc ];

  buildInputs = [ openssl ];

  makeFlags = [
    "HOSTCC=$(CC_FOR_BUILD)"
    "CROSS_COMPILE=${pkgsCross.aarch64-embedded.stdenv.cc.targetPrefix}"
    "PLAT=${platform}"
    "SPD=opteed"
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
    homepage = "https://github.com/nxp-imx/imx-atf";
    description = "Reference implementation of secure world software for ARMv8-A";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };
}

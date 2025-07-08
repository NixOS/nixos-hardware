{
  lib,
  fetchgit,
  enable-tee,
  stdenv,
  buildPackages,
  pkgsCross,
  openssl,
}:
let
  opteedflag = if enable-tee then "SPD=opteed" else "";
  target-board = "imx8mq";
in
stdenv.mkDerivation rec {
  pname = "imx8mq-atf";
  version = "lf6.1.55_2.2.0";
  platform = target-board;
  enableParallelBuilding = true;

  src = fetchgit {
    url = "https://github.com/nxp-imx/imx-atf.git";
    rev = "08e9d4eef2262c0dd072b4325e8919e06d349e02";
    sha256 = "sha256-96EddJXlFEkP/LIGVgNBvUP4IDI3BbDE/c9Yub22gnc=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # For Cortex-M0 firmware in RK3399
  nativeBuildInputs = [ pkgsCross.arm-embedded.stdenv.cc ];

  buildInputs = [ openssl ];

  makeFlags = [
    "HOSTCC=$(CC_FOR_BUILD)"
    "M0_CROSS_COMPILE=${pkgsCross.arm-embedded.stdenv.cc.targetPrefix}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
    # binutils 2.39 regression
    # `warning: /build/source/build/rk3399/release/bl31/bl31.elf has a LOAD segment with RWX permissions`
    # See also: https://developer.trustedfirmware.org/T996
    "LDFLAGS=-no-warn-rwx-segments"
    "PLAT=${platform}"
    "bl31"
    "${opteedflag}"
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
    maintainers = with maintainers; [ gngram ];
    platforms = [ "aarch64-linux" ];
  };
}

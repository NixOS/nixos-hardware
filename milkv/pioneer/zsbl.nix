{ buildPackages
, bison
, fetchFromGitHub
, flex
, lib
, stdenv

, ...
}:
stdenv.mkDerivation rec {
  pname = "zsbl-sg2042";
  version = "git-cc806273";
  src = fetchFromGitHub {
    owner = "sophgo";
    repo = "zsbl";
    rev = "cc806273e0f679bef2f6b017c68adede1594ad31";
    hash = "sha256-zOlBM7mwz8FUM/BlzOxJmpI8LI/KcFOGXegvgiilbaM=";
  };

  patches = [
    # Depending on the sdcard, reading larger initrds (say >= 25MB)
    # can hit the timeout.
    ./zsbl-increase-timeout.patch
  ];

  nativeBuildInputs = [
    bison
    flex
  ];
  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];
  hardeningDisable = [
    "fortify"
    "stackprotector"
  ];

  makeFlags = [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];
  configurePhase = "make sg2042_defconfig";
  installPhase = "install -D zsbl.bin $out";
  enableParallelBuilding = true;
  dontStrip = true;

  meta = {
    homepage = "https://github.com/sophgo/zsbl";
    description = "Sophgo RISC-V Zero Stage Boot Loader";
    license = lib.licenses.gpl2;
  };
}

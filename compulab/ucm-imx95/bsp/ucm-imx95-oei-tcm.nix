{
  lib,
  stdenv,
  buildPackages,
  gcc-arm-embedded,
  fetchFromGitHub,
  fetchpatch,
}:
let
  metaBspImx95Rev = "5f4c7b5db846fa3a75055054e32215089d15a7b7"; # scarthgap
in
stdenv.mkDerivation rec {
  pname = "imx95-imx-oei-tcm";
  version = "lf-6.6.36-2.1.0";

  nativeBuildInputs = [
    buildPackages.python3
    gcc-arm-embedded
  ];

  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "imx-oei";
    rev = "5fca9f47544d03c52ca371eadfffbfd2454e6925";
    sha256 = "sha256-Sb6u1NlhJpDCOKBu3HqUb4BLEy0F8LYVnJE0tRSvzWc=";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/${metaBspImx95Rev}/recipes-bsp/imx-oei/imx-oei/0001-Add-CompuLab-lpddr5_timing.c.patch";
      sha256 = "sha256-6ZpBOXw2aIhD2i9Wx368xfHq6NvdZghWHU9u8+gRTj8=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/${metaBspImx95Rev}/recipes-bsp/imx-oei/imx-oei/0002-board-mx95lp5-Fix-default-DDR_CONFIG-timing-name.patch";
      sha256 = "sha256-WZ/vYaTC2iKIC+jnHtnPriCxK9gjRsOv2Uy13Ye4698=";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/${metaBspImx95Rev}/recipes-bsp/imx-oei/imx-oei/0003-Add-CompuLab-lpddr5_timing_4g.c.patch";
      sha256 = "sha256-yyierv2USZlM8Cuxf4FDj4+UtILvJQH9BJSj+fmayL8=";
    })
  ];

  postPatch = ''
    substituteInPlace oei/makefiles/build_info.mak \
      --replace-fail "/bin/echo" "echo"
    substituteInPlace Makefile \
      --replace-fail "/bin/echo" "echo"
  '';

  makeFlags = [
    "board=mx95lp5"
    "CROSS_COMPILE=${gcc-arm-embedded}/bin/arm-none-eabi-"
    "OEI_CROSS_COMPILE=${gcc-arm-embedded}/bin/arm-none-eabi-"
    "ARCH=arm"
    "DDR_CONFIG=lpddr5_timing"
    "oei=tcm"
  ];

  installPhase = ''
    mkdir -p $out
    cp build/mx95lp5/tcm/oei-m33-tcm.bin $out/
  '';

  meta = with lib; {
    homepage = "https://github.com/nxp-imx/imx-oei";
    description = "Optional Executable Image assembler for i.MX95 processors";
    license = licenses.bsd3;
    maintainers = [
      {
        name = "Govind Singh";
        email = "govind.singh@tii.ae";
      }
    ];
    platforms = [ "aarch64-linux" ];
  };
}

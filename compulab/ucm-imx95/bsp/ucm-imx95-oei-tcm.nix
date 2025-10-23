{
  lib,
  pkgs,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "imx95-imx-oei-tcm";
  version = "lf-6.6.36-2.1.0";

  nativeBuildInputs = [
    pkgs.buildPackages.python3
    pkgs.gcc-arm-embedded
  ];

  src = pkgs.fetchgit {
    url = "https://github.com/nxp-imx/imx-oei.git";
    rev = "5fca9f47544d03c52ca371eadfffbfd2454e6925";
    sha256 = "sha256-Sb6u1NlhJpDCOKBu3HqUb4BLEy0F8LYVnJE0tRSvzWc=";
  };

  patches = [
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap/recipes-bsp/imx-oei/imx-oei/0001-Add-CompuLab-lpddr5_timing.c.patch";
      sha256 = "sha256-6ZpBOXw2aIhD2i9Wx368xfHq6NvdZghWHU9u8+gRTj8=";
    })
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap/recipes-bsp/imx-oei/imx-oei/0002-board-mx95lp5-Fix-default-DDR_CONFIG-timing-name.patch";
      sha256 = "sha256-WZ/vYaTC2iKIC+jnHtnPriCxK9gjRsOv2Uy13Ye4698=";
    })
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap/recipes-bsp/imx-oei/imx-oei/0003-Add-CompuLab-lpddr5_timing_4g.c.patch";
      sha256 = "sha256-yyierv2USZlM8Cuxf4FDj4+UtILvJQH9BJSj+fmayL8=";
    })
  ];

  postPatch = ''
    substituteInPlace oei/makefiles/build_info.mak \
      --replace "/bin/echo" "echo"
    substituteInPlace Makefile \
      --replace "/bin/echo" "echo"
  '';

  makeFlags = [
    "board=mx95lp5"
    "CROSS_COMPILE=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-"
    "OEI_CROSS_COMPILE=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-"
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
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };
}

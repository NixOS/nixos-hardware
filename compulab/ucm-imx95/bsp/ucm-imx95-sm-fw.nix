{
  lib,
  pkgs,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "imx95-sm-fw";
  version = "lf-6.6.36-2.1.0";

  nativeBuildInputs = [
    pkgs.buildPackages.python3
    pkgs.gcc-arm-embedded
  ];

  propagatedBuildInputs = with pkgs.buildPackages.python3.pkgs; [
    pycryptodomex
    pyelftools
    cryptography
  ];

  src = pkgs.fetchFromGitHub {
    owner = "nxp-imx";
    repo = "imx-sm";
    rev = "709deccd9338399eb39b5cf99a60eab4fa60d539";
    sha256 = "sha256-02Cl+XhWGSFswspdBJ/4B/mBm4XTs/qKotx0BXMQpJk=";
  };

  patches = [
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap-6.6.36-EVAL-UCM-iMX95-1.0/recipes-bsp/imx-system-manager/imx-system-manager/0001-Add-mcimx95cust-board.patch";
      sha256 = "sha256-zvZ4bNew+yRPmaZQMrAH087KpCLRqz6zdElfe72Dtuc=";
    })
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap-6.6.36-EVAL-UCM-iMX95-1.0/recipes-bsp/imx-system-manager/imx-system-manager/0002-Fix-null-pionter-except.patch";
      sha256 = "sha256-q72VEvJqm2CmOxdWMqGibgXS5lY08mC4srEcy00QdrE=";
    })
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap-6.6.36-EVAL-UCM-iMX95-1.0/recipes-bsp/imx-system-manager/imx-system-manager/0001-update-for-yocto-6.6.36-compatibility.patch";
      sha256 = "sha256-JzHqDiD/ZOu6VQQI0JxY17RQ3bA2t1aP3O1sjLPguWs=";
    })
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap-6.6.36-EVAL-UCM-iMX95-1.0/recipes-bsp/imx-system-manager/imx-system-manager/0003-sm-Disable-GPIO1-10-interrupt.patch";
      sha256 = "sha256-dhcDv7Uq856+MBonczMPznk+tuqUFxTcHiKLX+myCVA=";
    })
    (pkgs.fetchpatch {
      url = "https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx95/scarthgap-6.6.36-EVAL-UCM-iMX95-1.0/recipes-bsp/imx-system-manager/imx-system-manager/0004-configs-mx95cust-change-LPTPM1-ownership.patch";
      sha256 = "sha256-NcLu6+zXpiSz1bHKW14Zuf6F/4pzKsekb+zaRtKjSTY=";
    })
  ];

  postPatch = ''
    substituteInPlace sm/makefiles/gcc_cross.mak \
      --replace-fail "\$(SM_CROSS_COMPILE)objcopy" ${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-objcopy
    substituteInPlace sm/makefiles/build_info.mak \
      --replace-fail "/bin/echo" "echo"
    substituteInPlace sm/makefiles/gcc_cross.mak \
      --replace-fail 'SM_CROSS_COMPILE ?= $(TOOLS)/arm-gnu-toolchain-*-none-eabi/bin/arm-none-eabi-' \
                'SM_CROSS_COMPILE ?= $(CROSS_COMPILE)'
  '';

  makeFlags = [
    "config=mx95cust"
    "M=2"
    "CROSS_COMPILE=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-"
    "CROSS_COMPILE64=${pkgs.gcc-arm-embedded}/bin/arm-none-eabi-"
    "ARCH=arm"
  ];

  installPhase = ''
    mkdir -p $out
    cp build/mx95cust/m33_image.bin $out/
  '';

  meta = with lib; {
    homepage = "https://github.com/nxp-imx/imx-sm";
    description = "System Manager firmware for i.MX processors";
    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };
}

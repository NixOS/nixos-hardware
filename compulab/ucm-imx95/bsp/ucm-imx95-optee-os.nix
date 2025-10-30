{
  lib,
  pkgs,
}:
let
  inherit (pkgs.buildPackages) python3;
  toolchain = pkgs.gccStdenv.cc;
  binutils = pkgs.gccStdenv.cc.bintools.bintools_bin;
  cpp = pkgs.gcc;
in
pkgs.stdenv.mkDerivation rec {
  pname = "imx95-optee-os";
  version = "lf-6.6.36_2.1.0";

  nativeBuildInputs = [
    python3
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = with python3.pkgs; [
    pycryptodomex
    pyelftools
    cryptography
  ];

  src = pkgs.fetchFromGitHub {
    owner = "nxp-imx";
    repo = "imx-optee-os";
    rev = "612bc5a642a4608d282abeee2349d86de996d7ee";
    sha256 = "sha256-l8GKkrlBs5kgw6jrzGLT9WAeTSDqo8XWZDFT2+Fisv4=";
  };
  meta = with lib; {
    homepage = "https://github.com/nxp-imx/imx-optee-os";
    license = [ licenses.bsd2 ];
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };

  postPatch = ''
    substituteInPlace scripts/arm32_sysreg.py \
      --replace '/usr/bin/env python3' '${python3}/bin/python'
    substituteInPlace scripts/gen_tee_bin.py \
      --replace '/usr/bin/env python3' '${python3}/bin/python'
    substituteInPlace scripts/pem_to_pub_c.py \
      --replace '/usr/bin/env python3' '${python3}/bin/python'
    substituteInPlace ta/pkcs11/scripts/verify-helpers.sh \
      --replace '/bin/bash' '${pkgs.bash}/bin/bash'
    substituteInPlace mk/gcc.mk \
      --replace "\$(CROSS_COMPILE_\$(sm))objcopy" ${binutils}/bin/${toolchain.targetPrefix}objcopy
    substituteInPlace mk/gcc.mk \
      --replace "\$(CROSS_COMPILE_\$(sm))objdump" ${binutils}/bin/${toolchain.targetPrefix}objdump
    substituteInPlace mk/gcc.mk \
      --replace "\$(CROSS_COMPILE_\$(sm))nm" ${binutils}/bin/${toolchain.targetPrefix}nm
    substituteInPlace mk/gcc.mk \
      --replace "\$(CROSS_COMPILE_\$(sm))readelf" ${binutils}/bin/${toolchain.targetPrefix}readelf
    substituteInPlace mk/gcc.mk \
      --replace "\$(CROSS_COMPILE_\$(sm))ar" ${binutils}/bin/${toolchain.targetPrefix}ar
    substituteInPlace mk/gcc.mk \
      --replace "\$(CROSS_COMPILE_\$(sm))cpp" ${cpp}/bin/cpp
  '';

  makeFlags = [
    "PLATFORM=imx-mx95evk"
    "CFG_ARM64_core=y"
    "CFG_TEE_TA_LOG_LEVEL=0"
    "CFG_TEE_CORE_LOG_LEVEL=0"
    "CROSS_COMPILE=${toolchain}/bin/${toolchain.targetPrefix}"
    "CROSS_COMPILE64=${toolchain}/bin/${toolchain.targetPrefix}"
  ];

  installPhase = ''
    mkdir -p $out
    cp ./out/arm-plat-imx/core/tee-raw.bin $out/tee.bin
  '';
}

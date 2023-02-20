{
  pkgs,
}:

let

  pkgsCross = import <nixpkgs> {
     crossSystem = {
       config = "aarch64-unknown-linux-gnu";
     };
  };

  outdir = "out/arm-plat-imx/core";
  python3 = pkgs.buildPackages.python3;
  toolchain = pkgsCross.gcc9Stdenv.cc;
  binutils = pkgsCross.gcc9Stdenv.cc.bintools.bintools_bin;
  cpp = pkgs.buildPackages.gcc;

in
pkgs.stdenv.mkDerivation rec {
  
  pname = "imx-optee-os";
  version = "5.15.32_2.0.0";

  buildInputs = [
    python3
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = with python3.pkgs; [
    pycryptodomex
    pyelftools
    cryptography
  ];

  src = fetchGit {
    url = "https://source.codeaurora.org/external/imx/imx-optee-os.git";
    ref = "lf-5.15.32_2.0.0";
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
    "PLATFORM=imx"
    "PLATFORM_FLAVOR=mx8qmmek"
    "CFG_ARM64_core=y"
    "CFG_TEE_TA_LOG_LEVEL=0"
    "CFG_TEE_CORE_LOG_LEVEL=0"
    "CROSS_COMPILE=${toolchain}/bin/${toolchain.targetPrefix}"
    "CROSS_COMPILE64=${toolchain}/bin/${toolchain.targetPrefix}"
  ];

  installPhase = ''
    mkdir -p $out
    cp ${outdir}/tee-raw.bin $out/tee.bin
  '';
}

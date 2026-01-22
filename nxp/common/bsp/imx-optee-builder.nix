# Parameterized OP-TEE OS builder for i.MX platforms
# This builder is used across i.MX93, i.MX8MP, i.MX8MQ and similar platforms
{
  lib,
  pkgs,
  # Platform-specific parameters
  pname,
  version,
  platformFlavor,
  src,
  # Optional parameters
  meta ? { },
}:
let
  inherit (pkgs.buildPackages) python3;
  toolchain = pkgs.stdenv.cc;
  binutils = pkgs.stdenv.cc.bintools.bintools_bin;
  cpp = pkgs.stdenv.cc;

  # Determine PLATFORM and PLATFORM_FLAVOR from platformFlavor
  # Format can be either "imx-mx93evk" (full platform string) or "mx8mpevk" (just flavor, platform is "imx")
  # Check if it starts with "imx-" to determine if it's a full platform string or just a flavor
  hasFullPlatform = lib.hasPrefix "imx-" platformFlavor;
  platform = if hasFullPlatform then platformFlavor else "imx";
  flavor = if hasFullPlatform then null else platformFlavor;
in
pkgs.stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    python3
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = with python3.pkgs; [
    pycryptodomex
    pyelftools
    cryptography
  ];

  # Common postPatch for all i.MX platforms
  # This is the major source of code duplication - ~60 lines of identical substitutions
  postPatch = ''
    # Patch all script shebangs automatically
    patchShebangs scripts/
    patchShebangs ta/

    # Patch toolchain paths in mk/gcc.mk
    substituteInPlace mk/gcc.mk \
      --replace-fail "\$(CROSS_COMPILE_\$(sm))objcopy" ${binutils}/bin/${toolchain.targetPrefix}objcopy
    substituteInPlace mk/gcc.mk \
      --replace-fail "\$(CROSS_COMPILE_\$(sm))objdump" ${binutils}/bin/${toolchain.targetPrefix}objdump
    substituteInPlace mk/gcc.mk \
      --replace-fail "\$(CROSS_COMPILE_\$(sm))nm" ${binutils}/bin/${toolchain.targetPrefix}nm
    substituteInPlace mk/gcc.mk \
      --replace-fail "\$(CROSS_COMPILE_\$(sm))readelf" ${binutils}/bin/${toolchain.targetPrefix}readelf
    substituteInPlace mk/gcc.mk \
      --replace-fail "\$(CROSS_COMPILE_\$(sm))ar" ${binutils}/bin/${toolchain.targetPrefix}ar
    substituteInPlace mk/gcc.mk \
      --replace-fail "\$(CROSS_COMPILE_\$(sm))cpp" ${cpp}/bin/${toolchain.targetPrefix}cpp
  '';

  makeFlags = [
    "PLATFORM=${platform}"
  ]
  ++ lib.optionals (!hasFullPlatform) [
    "PLATFORM_FLAVOR=${flavor}"
  ]
  ++ [
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

  meta = {
    homepage = "https://github.com/nxp-imx/imx-optee-os";
    license = [ lib.licenses.bsd2 ];
    platforms = [ "aarch64-linux" ];
  }
  // meta;
}

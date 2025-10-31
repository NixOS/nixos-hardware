# Parameterized U-Boot builder for i.MX platforms
# This builder is used across i.MX93, i.MX8MP, i.MX8MQ and similar platforms
{
  lib,
  stdenv,
  buildPackages,
  # Required dependencies
  bison,
  dtc,
  flex,
  gnutls,
  libuuid,
  ncurses,
  openssl,
  perl,
  efitools,
  which,
  # Platform-specific parameters
  pname,
  version,
  src,
  defconfig,
  ramdiskAddr,
  fdtAddr,
  dtbPath,
  # Optional parameters
  extraConfig ? "",
  extraNativeBuildInputs ? [ ],
}:
let
  # Import common U-Boot configuration
  ubootConfig = import ../lib/uboot-config.nix;

  # Generate the common config with platform-specific memory addresses
  commonConfig = ubootConfig.imxCommonUbootConfig {
    inherit ramdiskAddr fdtAddr;
  };

  # Combine common config with any platform-specific extra config
  finalExtraConfig = commonConfig + extraConfig;
in
stdenv.mkDerivation {
  inherit pname version src;

  postPatch = ''
    patchShebangs tools
    patchShebangs scripts
  '';

  nativeBuildInputs = [
    bison
    flex
    openssl
    which
    ncurses
    libuuid
    gnutls
    perl
    efitools
  ]
  ++ extraNativeBuildInputs;

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  hardeningDisable = [ "all" ];
  enableParallelBuilding = true;

  makeFlags = [
    "DTC=${lib.getExe buildPackages.dtc}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  extraConfig = finalExtraConfig;

  passAsFile = [ "extraConfig" ];

  configurePhase = ''
    runHook preConfigure

    make ${defconfig}
    cat $extraConfigPath >> .config

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp ./u-boot-nodtb.bin $out
    cp ./spl/u-boot-spl.bin $out
    cp ${dtbPath} $out
    cp .config  $out

    runHook postInstall
  '';

  dontStrip = true;
}

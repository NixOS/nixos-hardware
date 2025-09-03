{
  stdenv,
  lib,
  bison,
  dtc,
  fetchgit,
  flex,
  gnutls,
  libuuid,
  ncurses,
  openssl,
  which,
  perl,
  buildPackages,
  efitools,
}:
let
  ubsrc = fetchgit {
    url = "https://github.com/nxp-imx/uboot-imx.git";
    # tag: lf-6.12.20-2.0.0
    rev = "9383f8387dc76524524da69992db96c22195a57c";
    sha256 = "sha256-httRSwN8NiKOdL7fZEvN/4AbypGQfegYtJgxKIea+Zg=";
  };
in
stdenv.mkDerivation {
  pname = "imx8mp-uboot";
  version = "2025.04";
  src = ubsrc;

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
    openssl
    perl
    efitools
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  hardeningDisable = [ "all" ];
  enableParallelBuilding = true;

  makeFlags = [
    "DTC=${lib.getExe buildPackages.dtc}"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  extraConfig = ''
    CONFIG_USE_BOOTCOMMAND=y
    CONFIG_BOOTCOMMAND="setenv ramdisk_addr_r 0x45000000; setenv fdt_addr_r 0x44000000; run distro_bootcmd; "
    CONFIG_CMD_BOOTEFI_SELFTEST=y
    CONFIG_CMD_BOOTEFI=y
    CONFIG_EFI_LOADER=y
    CONFIG_BLK=y
    CONFIG_PARTITIONS=y
    CONFIG_DM_DEVICE_REMOVE=n
    CONFIG_CMD_CACHE=y
  '';

  passAsFile = [ "extraConfig" ];

  configurePhase = ''
    runHook preConfigure

    make imx8mp_evk_defconfig
    cat $extraConfigPath >> .config

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp ./u-boot-nodtb.bin $out
    cp ./spl/u-boot-spl.bin $out
    cp ./dts/upstream/src/arm64/freescale/imx8mp-evk.dtb $out
    cp .config  $out

    runHook postInstall
  '';

  dontStrip = true;
}

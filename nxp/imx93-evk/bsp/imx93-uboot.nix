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
    #lf_v2024.04
    rev = "e3219a5a73445219df605d1492687918d488055c";
    sha256 = "sha256-6pXwgNzq4/XUUEmJ6sGC5pII4J5uMvlDPE9QJxjJJbQ=";
  };
  meta = with lib; {
    homepage = "https://github.com/nxp-imx/uboot-imx";
    license = [ licenses.gpl2Only ];
    maintainers = with maintainers; [ govindsi ];
    platforms = [ "aarch64-linux" ];
  };
in
stdenv.mkDerivation {
  pname = "imx93-uboot";
  version = "2024.04";
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
    CONFIG_BOOTCOMMAND="setenv ramdisk_addr_r 0x85000000; setenv fdt_addr_r 0x84000000; run distro_bootcmd; "
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

    make imx93_11x11_evk_defconfig
    cat $extraConfigPath >> .config

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp ./u-boot-nodtb.bin $out
    cp ./spl/u-boot-spl.bin $out
    cp ./arch/arm/dts/imx93-11x11-evk.dtb $out
    cp .config  $out

    runHook postInstall
  '';

  dontStrip = true;
}

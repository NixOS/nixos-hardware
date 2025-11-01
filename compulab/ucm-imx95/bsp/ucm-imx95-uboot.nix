{
  stdenv,
  lib,
  bison,
  dtc,
  fetchFromGitHub,
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
  ubsrc = fetchFromGitHub {
    owner = "compulab-yokneam";
    repo = "u-boot-compulab";
    # tag: lf_v2024.04
    rev = "824401fe487d7d3cbcf251bd60270bd7fe8d21d0";
    sha256 = "sha256-m+YW7+XF/jcNKfyb5533LXGyOWvStqY+MCczAdcNGZI=";
  };
in
stdenv.mkDerivation {
  pname = "imx95-uboot";
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
    CONFIG_BOOTCOMMAND="setenv ramdisk_addr_r 0x97000000; setenv fdt_addr_r 0x96000000; run distro_bootcmd; "
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

    make ucm-imx95_defconfig
    cat $extraConfigPath >> .config
    make olddefconfig

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp ./u-boot-nodtb.bin $out
    cp ./spl/u-boot-spl.bin $out
    cp ./arch/arm/dts/ucm-imx95.dtb $out
    cp .config  $out

    runHook postInstall
  '';

  dontStrip = true;
}

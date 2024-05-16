{ stdenv
, lib
, bison
, dtc
, fetchgit
, flex
, gnutls
, libuuid
, ncurses
, openssl
, which
, perl
, buildPackages
}:
let
  ubsrc = fetchgit {
      url = "https://github.com/nxp-imx/uboot-imx.git";
      # tag: "lf-6.1.55-2.2.0"
      rev = "49b102d98881fc28af6e0a8af5ea2186c1d90a5f";
      sha256 = "sha256-1j6X82DqezEizeWoSS600XKPNwrQ4yT0vZuUImKAVVA=";
    };
in
  (stdenv.mkDerivation {
    pname = "imx8mq-uboot";
    version = "2023.04";
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

      make imx8mq_evk_defconfig
      cat $extraConfigPath >> .config

      runHook postConfigure
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp ./u-boot-nodtb.bin $out
      cp ./spl/u-boot-spl.bin $out
      cp ./arch/arm/dts/imx8mq-evk.dtb $out
      cp .config  $out

      runHook postInstall
    '';

    dontStrip = true;
  })

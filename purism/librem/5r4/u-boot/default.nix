{ stdenv, buildUBoot, fetchurl, fetchFromGitLab, lib, flex, bison }:
let
  firmware-imx = stdenv.mkDerivation (fa: {
    pname = "firmware-imx";
    version = "8.12";
    src = fetchurl {
      url = "https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/${fa.pname}-${fa.version}.bin";
      sha256 = "1vr2wgjac718hp48arhdvxd7gib93zhdrbrla8w3xigc6szlfrvb";
    };
    unpackPhase = ''
      cp $src firmware
      chmod +x firmware
      ./firmware --auto-accept
    '';
    installPhase = ''
      mkdir -p $out
      cd ${fa.pname}-${fa.version}/firmware
      cp ddr/synopsys/lpddr4_pmu_train_?d_?mem.bin hdmi/cadence/signed_*_imx8m.bin $out
    '';
    meta.license = lib.licenses.unfree;
  });

  arm-trusted-firmware-imx8mq = stdenv.mkDerivation (fa: {
    pname = "arm-trusted-firmware-bl31";
    version = "unstable-2020-07-08";
    src = fetchFromGitLab {
      domain = "source.puri.sm";
      owner = "Librem5";
      repo = "arm-trusted-firmware";
      rev = "1fd3ff86cd4a05cd3e5637bf5a6902ac58fcafb9";
      hash = "sha256-fzpUxq+Hz7pijv5Mvzz+bUkaH79YSaugVUnViF7NB3A=";
    };
    enableParallelBuilding = true;
    hardeningDisable = [ "all" ];
    NIX_LDFLAGS = "--no-warn-rwx-segments";
    buildFlags = [ "PLAT=imx8mq" "bl31" ];
    installPhase = ''
      mkdir -p $out
      cp build/imx8mq/release/bl31.bin $out
    '';
    dontStrip = true;
  });

  ubootLibrem5 = buildUBoot {
    version = "2022.10-librem5.1";
    defconfig = "librem5_defconfig";
    src = fetchFromGitLab {
      domain = "source.puri.sm";
      owner = "a-wai";
      repo = "uboot-imx";
      rev = "3a836701279ed1f51063dc5da6f59adc4809093e";
      hash = "sha256-69auZ8GzyhSBxzi4jc6IyyQ6JBrTYXaOk6dZ+joUgF4=";
    };
    BL31 = "${arm-trusted-firmware-imx8mq}/bl31.bin";
    preConfigure = ''
      cp $BL31 .
      cp ${firmware-imx}/* .
    '';
    preInstall = ''
      cp flash.bin u-boot.imx
    '';
    filesToInstall = [ "u-boot.imx" ];
    postInstall = ''
      mkdir $out/bin
      sed 's|TARGET="/usr/lib/u-boot/librem5.*"|TARGET="${placeholder "out"}"|' \
        $src/debian/bin/u-boot-install-librem5 > $out/bin/u-boot-install-librem5
    '';
  };
in
ubootLibrem5

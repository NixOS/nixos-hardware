{
  pkgs,
  enable-tee ? false,
}:
with pkgs; let
  cp-tee =
    if enable-tee
    then "install -m 0644 ${imx8mq-optee-os}/tee.bin ./iMX8M/tee.bin"
    else "";

  imx8mq-atf = pkgs.callPackage ./imx8mq-atf.nix {
    inherit (pkgs) buildArmTrustedFirmware;
    inherit enable-tee;
  };
  imx8mq-firmware = pkgs.callPackage ./imx8mq-firmware.nix {};
  imx8mq-uboot = pkgs.callPackage ./imx8mq-uboot.nix {};
  imx8mq-optee-os = pkgs.callPackage ./imx8mq-optee-os.nix {};
in {
  imx8m-boot = pkgs.stdenv.mkDerivation rec {
    name = "imx8mq-mkimage";
    version = "lf-6.1.55-2.2.0";
    src = pkgs.fetchgit {
      url = "https://github.com/nxp-imx/imx-mkimage.git";
      rev = "c4365450fb115d87f245df2864fee1604d97c06a";
      sha256 = "sha256-xycEaWKVM63BlDyBKNN0OefyK6iX/fQOTvv4fRVM55U=";
      leaveDotGit = true;
    };

    postPatch = ''
      substituteInPlace Makefile \
          --replace 'CC = gcc' 'CC = clang'
      patchShebangs scripts
    '';

    nativeBuildInputs = [
      clang
      git
      dtc
    ];

    buildInputs = [
      git
      glibc.static
      zlib
      zlib.static
    ];

    buildPhase = ''
      runHook preBuild

      make bin
      make SOC=iMX8M mkimage_imx8
      cp -v ${pkgs.ubootTools}/bin/mkimage ./iMX8M/mkimage_uboot

      install -m 0644 ${imx8mq-uboot}/u-boot-spl.bin ./iMX8M/u-boot-spl.bin
      install -m 0644 ${imx8mq-uboot}/u-boot-nodtb.bin ./iMX8M/u-boot-nodtb.bin
      install -m 0644 ${imx8mq-uboot}/imx8mq-evk.dtb ./iMX8M/imx8mq-evk.dtb
      install -m 0644 ${imx8mq-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_dmem.bin ./iMX8M/lpddr4_pmu_train_1d_dmem.bin
      install -m 0644 ${imx8mq-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_imem.bin ./iMX8M/lpddr4_pmu_train_1d_imem.bin
      install -m 0644 ${imx8mq-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_dmem.bin ./iMX8M/lpddr4_pmu_train_2d_dmem.bin
      install -m 0644 ${imx8mq-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_imem.bin ./iMX8M/lpddr4_pmu_train_2d_imem.bin
      install -m 0644 ${imx8mq-firmware}/firmware/hdmi/cadence/signed_hdmi_imx8m.bin ./iMX8M/signed_hdmi_imx8m.bin
      install -m 0644 ${imx8mq-atf}/bl31.bin ./iMX8M/bl31.bin
      ${cp-tee}

      make SOC=iMX8M flash_evk

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/image
      install -m 0644 ./iMX8M/flash.bin $out/image
      runHook postInstall
    '';
  };
}

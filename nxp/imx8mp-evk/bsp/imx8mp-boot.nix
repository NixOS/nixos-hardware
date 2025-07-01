{
  pkgs,
  enable-tee ? true,
}:
with pkgs;
let
  fw-ver = "202006";
  cp-tee = if enable-tee then "install -m 0644 ${imx8mp-optee-os}/tee.bin ./iMX8M/tee.bin" else "";

  imx8mp-atf = pkgs.callPackage ./imx8mp-atf.nix {
    inherit enable-tee;
  };
  imx8mp-firmware = pkgs.callPackage ./imx8mp-firmware.nix { };
  imx8mp-uboot = pkgs.callPackage ./imx8mp-uboot.nix { };
  imx8mp-optee-os = pkgs.callPackage ./imx8mp-optee-os.nix { };
  src = pkgs.fetchgit {
    url = "https://github.com/nxp-imx/imx-mkimage.git";
    rev = "c4365450fb115d87f245df2864fee1604d97c06a";
    sha256 = "sha256-KVIVHwBpAwd1RKy3RrYxGIniE45CDlN5RQTXsMg1Jwk=";
  };
  shortRev = builtins.substring 0 8 src.rev;
in
{
  imx8m-boot = pkgs.stdenv.mkDerivation rec {
    inherit src;
    name = "imx8mp-mkimage";
    version = "lf-6.1.55-2.2.0";

    postPatch = ''
      substituteInPlace Makefile \
          --replace 'git rev-parse --short=8 HEAD' 'echo ${shortRev}'
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
      make SOC=iMX8MP mkimage_imx8

      cp -v ${pkgs.ubootTools}/bin/mkimage ./iMX8M/mkimage_uboot

      install -m 0644 ${imx8mp-uboot}/u-boot-spl.bin ./iMX8M/u-boot-spl.bin
      install -m 0644 ${imx8mp-uboot}/u-boot-nodtb.bin ./iMX8M/u-boot-nodtb.bin
      install -m 0644 ${imx8mp-uboot}/imx8mp-evk.dtb ./iMX8M/imx8mp-evk.dtb
      install -m 0644 ${imx8mp-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_dmem_${fw-ver}.bin ./iMX8M/lpddr4_pmu_train_1d_dmem_${fw-ver}.bin
      install -m 0644 ${imx8mp-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_1d_imem_${fw-ver}.bin ./iMX8M/lpddr4_pmu_train_1d_imem_${fw-ver}.bin
      install -m 0644 ${imx8mp-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_dmem_${fw-ver}.bin ./iMX8M/lpddr4_pmu_train_2d_dmem_${fw-ver}.bin
      install -m 0644 ${imx8mp-firmware}/firmware/ddr/synopsys/lpddr4_pmu_train_2d_imem_${fw-ver}.bin ./iMX8M/lpddr4_pmu_train_2d_imem_${fw-ver}.bin
      install -m 0644 ${imx8mp-firmware}/firmware/hdmi/cadence/signed_hdmi_imx8m.bin ./iMX8M/signed_hdmi_imx8m.bin
      install -m 0644 ${imx8mp-atf}/bl31.bin ./iMX8M/bl31.bin
      ${cp-tee}

      make SOC=iMX8MP flash_evk

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

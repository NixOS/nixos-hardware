{
  pkgs,
  enable-tee ? true,
}:
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
    #tag: lf-6.12.20_2.0.0
    rev = "4c2e5b25232f5aa003976ddca9d1d2fb9667beb1";
    sha256 = "sha256-bXvM5Q0Fsb18gupw6/ub62/qNE7wGLaZKugp0URWeUk=";
  };
  shortRev = builtins.substring 0 8 src.rev;
in
{
  imx8m-boot = pkgs.buildPackages.stdenv.mkDerivation {
    inherit src;
    name = "imx8mp-mkimage";
    version = "lf-6.1.55-2.2.0";

    postPatch = ''
      substituteInPlace Makefile \
          --replace 'git rev-parse --short=8 HEAD' 'echo ${shortRev}'
      patchShebangs scripts
    '';

    nativeBuildInputs = [
      pkgs.buildPackages.stdenv.cc
      pkgs.buildPackages.git
      pkgs.buildPackages.dtc
      pkgs.buildPackages.glibc.static
      pkgs.buildPackages.zlib
      pkgs.buildPackages.zlib.static
    ];

    buildPhase = ''
      runHook preBuild

      make bin
      make SOC=iMX8MP mkimage_imx8

      cp -v ${pkgs.buildPackages.ubootTools}/bin/mkimage ./iMX8M/mkimage_uboot

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

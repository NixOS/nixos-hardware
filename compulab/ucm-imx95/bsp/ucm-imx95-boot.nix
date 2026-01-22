{
  callPackage,
  fetchFromGitHub,
  stdenv,
  clang,
  git,
  dtc,
  glibc,
  zlib,
  vim,
}:
let

  imx95-atf = callPackage ./ucm-imx95-atf.nix { };
  imx95-firmware = callPackage ./ucm-imx95-firmware.nix { };
  imx95-uboot = callPackage ./ucm-imx95-uboot.nix { };
  imx95-optee-os = callPackage ./ucm-imx95-optee-os.nix { };
  imx95-sm-fw = callPackage ./ucm-imx95-sm-fw.nix { };
  imx95-oei-ddr = callPackage ./ucm-imx95-oei-ddr.nix { };
  imx95-oei-tcm = callPackage ./ucm-imx95-oei-tcm.nix { };
  src = fetchFromGitHub {
    owner = "nxp-imx";
    repo = "imx-mkimage";
    #tag: lf-6.6.52-2.2.1
    rev = "f620fb8ef7a04c8dbed8119880f5eeffe3e69746";
    sha256 = "sha256-JZlX122uZntCIISI1H3Hw+tnk+N/gBJpFFDaZoY8W3c=";
  };
  shortRev = builtins.substring 0 8 src.rev;
in
{
  imx95-boot = stdenv.mkDerivation rec {
    inherit src;
    name = "imx95-mkimage";
    version = "lf-6.6.52-2.2.1";

    postPatch = ''
      substituteInPlace Makefile \
          --replace-fail 'git rev-parse --short=8 HEAD' 'echo ${shortRev}'
      substituteInPlace Makefile \
          --replace-fail 'CC = gcc' 'CC = clang'
      substituteInPlace iMX95/soc.mak \
        --replace-fail 'xxd' "${vim.xxd}/bin/xxd"
      substituteInPlace scripts/fspi_fcb_gen.sh \
        --replace-fail 'xxd' "${vim.xxd}/bin/xxd"
      substituteInPlace scripts/fspi_packer.sh \
        --replace-fail 'xxd' "${vim.xxd}/bin/xxd"
      patchShebangs scripts
    '';

    nativeBuildInputs = [
      clang
      git
      dtc
    ];

    buildInputs = [
      glibc.static
      zlib
      zlib.static
    ];

    buildPhase = ''
      runHook preBuild

      if [ -f ${imx95-uboot}/u-boot.bin ]; then
        install -m 0644 ${imx95-uboot}/u-boot.bin ./iMX95/u-boot.bin
      else
       cat ${imx95-uboot}/u-boot-nodtb.bin ${imx95-uboot}/ucm-imx95.dtb > ./iMX95/u-boot.bin
      fi
      install -m 0644 ${imx95-uboot}/u-boot-spl.bin ./iMX95/u-boot-spl.bin
      install -m 0644 ${imx95-uboot}/u-boot-nodtb.bin ./iMX95/u-boot-nodtb.bin
      install -m 0644 ${imx95-uboot}/ucm-imx95.dtb ./iMX95/ucm-imx95.dtb
      install -m 0644 ${imx95-optee-os}/tee.bin ./iMX95/tee.bin
      install -m 0644 ${imx95-atf}/bl31.bin ./iMX95/bl31.bin
      install -m 0644 ${imx95-sm-fw}/m33_image.bin ./iMX95/m33_image.bin
      install -m 0644 ${imx95-oei-ddr}/oei-m33-ddr.bin ./iMX95/oei-m33-ddr.bin
      install -m 0644 ${imx95-oei-tcm}/oei-m33-tcm.bin ./iMX95/oei-m33-tcm.bin
      install -m 0644 ${imx95-firmware}/ddr/lpddr5* ./iMX95/
      install -m 0644 ${imx95-firmware}/ahab/mx95a0-ahab-container.img ./iMX95/
      install -m 0644 ${imx95-firmware}/m7_image.bin ./iMX95/

      make SOC=iMX95 REV=A0 OEI=YES LPDDR_TYPE=lpddr5 flash_all

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/image
      install -m 0644 ./iMX95/flash.bin $out/image
      runHook postInstall
    '';
  };
}

{
  pkgs,
}:
with pkgs;
let

  imx93-atf = pkgs.callPackage ./imx93-atf.nix { };
  imx93-firmware = pkgs.callPackage ./imx93-firmware.nix { };
  imx93-uboot = pkgs.callPackage ./imx93-uboot.nix { };
  imx93-optee-os = pkgs.callPackage ./imx93-optee-os.nix { };
  src = pkgs.fetchgit {
    url = "https://github.com/nxp-imx/imx-mkimage.git";
    #tag: lf-6.12.3
    rev = "4622115cbc037f79039c4522faeced4aabea986b";
    sha256 = "sha256-2gz0GxlB3jwy8PC6+cP3+MpyUzqE1vDTw8nuxK6vo3g=";
  };
  shortRev = builtins.substring 0 8 src.rev;
in
{
  imx93-boot = pkgs.stdenv.mkDerivation rec {
    inherit src;
    name = "imx93-mkimage";
    version = "lf-6.12.3";

    postPatch = ''
      substituteInPlace Makefile \
          --replace 'git rev-parse --short=8 HEAD' 'echo ${shortRev}'
      substituteInPlace Makefile \
          --replace 'CC = gcc' 'CC = clang'
      substituteInPlace iMX93/soc.mak \
        --replace 'xxd' "${pkgs.vim.xxd}/bin/xxd"
      substituteInPlace scripts/fspi_fcb_gen.sh \
        --replace 'xxd' "${pkgs.vim.xxd}/bin/xxd"
      substituteInPlace scripts/fspi_packer.sh \
        --replace 'xxd' "${pkgs.vim.xxd}/bin/xxd"
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
      # mkimage is common across imx8 and imx9
      make SOC=iMX8M mkimage_imx8

      if [ -f ${imx93-uboot}/u-boot.bin ]; then
        install -m 0644 ${imx93-uboot}/u-boot.bin ./iMX93/u-boot.bin
      else
       cat ${imx93-uboot}/u-boot-nodtb.bin ${imx93-uboot}/imx93-11x11-evk.dtb > ./iMX93/u-boot.bin
      fi
      install -m 0644 ${imx93-uboot}/u-boot-spl.bin ./iMX93/u-boot-spl.bin
      install -m 0644 ${imx93-uboot}/u-boot-nodtb.bin ./iMX93/u-boot-nodtb.bin
      install -m 0644 ${imx93-uboot}/imx93-11x11-evk.dtb ./iMX93/imx93-11x11-evk.dtb
      install -m 0644 ${imx93-optee-os}/tee.bin ./iMX93/tee.bin
      install -m 0644 ${imx93-atf}/bl31.bin ./iMX93/bl31.bin
      install -m 0644 ${imx93-firmware}/ddr/lpddr4* ./iMX93/
      install -m 0644 ${imx93-firmware}/ahab/mx93a1-ahab-container.img ./iMX93/

      make SOC=iMX9 flash_singleboot

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/image
      install -m 0644 ./iMX93/flash.bin $out/image
      runHook postInstall
    '';
  };
}

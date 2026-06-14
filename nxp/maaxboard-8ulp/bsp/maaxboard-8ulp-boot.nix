{
  pkgs,
}:
with pkgs;
let
  maaxboard-8ulp-atf = pkgs.callPackage ./maaxboard-8ulp-atf.nix { };
  maaxboard-8ulp-firmware = pkgs.callPackage ./maaxboard-8ulp-firmware.nix { };
  maaxboard-8ulp-uboot = pkgs.callPackage ./maaxboard-8ulp-uboot.nix { };
  src = pkgs.fetchgit {
    url = "https://github.com/Avnet/imx-mkimage.git";
    rev = "5cfd218012e080fb907d9cc301fbb4ece9bc17a9";
    sha256 = "sha256-u6+pGk0Uw/foRmVqSep/Q3mRywxctlmzoOpNxBNJBo8=";
  };
  shortRev = builtins.substring 0 8 src.rev;
in
{
  maaxboard-8ulp-boot = pkgs.stdenv.mkDerivation rec {
    inherit src;
    name = "maaxboard-8ulp-mkimage";
    version = "lf-6.1.22-2.0.0";

    postPatch = ''
      substituteInPlace Makefile \
          --replace 'git rev-parse --short=8 HEAD' 'echo ${shortRev}'
      patchShebangs scripts
    '';

    nativeBuildInputs = [
      stdenv.cc
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
      make SOC=iMX8ULP mkimage_imx8

      # Match Avnet maaxboard-build-tools imx-mkimage staging (REV=A2 silicon).
      install -m 0644 ${maaxboard-8ulp-uboot}/u-boot.bin ./iMX8ULP/u-boot.bin
      install -m 0644 ${maaxboard-8ulp-uboot}/u-boot-nodtb.bin ./iMX8ULP/u-boot-nodtb.bin
      install -m 0644 ${maaxboard-8ulp-uboot}/u-boot-spl.bin ./iMX8ULP/u-boot-spl.bin
      install -m 0644 ${maaxboard-8ulp-uboot}/maaxboard-8ulp.dtb ./iMX8ULP/imx8ulp-evk.dtb
      install -m 0755 ${maaxboard-8ulp-uboot}/mkimage_uboot ./iMX8ULP/mkimage_uboot
      install -m 0644 ${maaxboard-8ulp-atf}/bl31.bin ./iMX8ULP/bl31.bin
      install -m 0644 ${maaxboard-8ulp-firmware}/mx8ulpa2-ahab-container.img ./iMX8ULP/mx8ulpa2-ahab-container.img
      install -m 0644 ${maaxboard-8ulp-firmware}/upower.bin ./iMX8ULP/upower.bin
      install -m 0644 ${maaxboard-8ulp-firmware}/m33_image.bin ./iMX8ULP/m33_image.bin

      make SOC=iMX8ULP REV=A2 flash_singleboot_m33

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/image
      install -m 0644 ./iMX8ULP/flash.bin $out/image
      runHook postInstall
    '';
  };
}

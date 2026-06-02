{ pkgs }:

let
  qrb2210-uboot = pkgs.callPackage ./qrb2210-uboot.nix { };
in
{
  qrb2210-boot = pkgs.stdenvNoCC.mkDerivation {
    pname = "qrb2210-boot";
    version = qrb2210-uboot.version;

    nativeBuildInputs = [
      pkgs.android-tools
      pkgs.ubootTools
    ];

    dontUnpack = true;

    buildPhase = ''
      runHook preBuild

      touch empty-ramdisk
      mkimage -C none -A arm64 -T script -d ${./boot-qrb2210.cmd} boot.scr

      mkbootimg \
        --base 0x80000000 \
        --pagesize 4096 \
        --kernel ${qrb2210-uboot}/u-boot-nodtb.bin.gz-dtb \
        --cmdline "root=/dev/notreal" \
        --ramdisk empty-ramdisk \
        --output boot.img

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm0644 boot.img $out/boot.img
      install -Dm0644 boot.scr $out/boot.scr
      install -Dm0644 ${./boot-qrb2210.cmd} $out/boot.cmd
      install -Dm0644 ${./qrb2210Env.txt} $out/qrb2210Env.txt
      ln -s ${qrb2210-uboot} $out/u-boot

      runHook postInstall
    '';
  };
}


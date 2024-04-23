{ stdenv
, writeText
, opensbi
, fip
, zsbl
, linuxboot-kernel
, linuxboot-initrd
, dtbs ? "${linuxboot-kernel}/dtbs"
, ...
}:

let
  # Configure a conf.init for linuxboot. If this is not found on the sdcard,
  # zsbl will load it from spi flash even when booting from sd. That conf.ini
  # might be configured differently and thus not properly boot from sd.
  conf-ini = writeText "conf.ini" ''
    [sophgo-config]

    [devicetree]
    name = mango-milkv-pioneer.dtb

    [kernel]
    name = riscv64_Image

    [firmware]
    name = fw_dynamic.bin

    [ramfs]
    name = initrd.img

    [eof]
  '';
in

stdenv.mkDerivation {
  name = "milkv-pioneer-firmware";
  buildCommand = ''
    install -D ${conf-ini} $out/riscv64/conf.ini
    install -D ${fip} $out/fip.bin
    install -D ${zsbl} $out/zsbl.bin
    install -D ${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin $out/riscv64/
    install -D ${linuxboot-initrd}/initrd.img $out/riscv64/
    install -D ${dtbs}/sophgo/mango-milkv-pioneer.dtb $out/riscv64/
    install -D ${linuxboot-kernel}/Image $out/riscv64/riscv64_Image
  '';
}

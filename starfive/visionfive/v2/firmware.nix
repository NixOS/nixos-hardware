{ callPackage
, writeShellApplication
, stdenv
, mtdutils
}:

rec {
  opensbi = callPackage ./opensbi.nix { };
  uboot = callPackage ./uboot.nix { inherit opensbi; };
  updater-flash = writeShellApplication {
    name = "visionfive2-firmware-update-flash";
    runtimeInputs = [ mtdutils ];
    text = ''
      flashcp -v ${uboot}/u-boot-spl.bin.normal.out /dev/mtd0
      flashcp -v ${uboot}/u-boot.itb /dev/mtd2
    '';
  };
  updater-sd = writeShellApplication {
    name = "visionfive2-firmware-update-sd";
    runtimeInputs = [ ];
    text = ''
      dd if=${uboot}/u-boot-spl.bin.normal.out of=/dev/mmcblk0p1 conv=fsync
      dd if=${uboot}/u-boot.itb of=/dev/mmcblk0p2 conv=fsync
    '';
  };
}

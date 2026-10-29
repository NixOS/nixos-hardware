final: _prev: {
  qrb2210-uboot = final.callPackage ./bsp/qrb2210-uboot.nix { };
  qrb2210-linux = final.callPackage ./bsp/qrb2210-linux.nix { };
  qrb2210-firmware = final.callPackage ./bsp/qrb2210-firmware.nix { };
  qrb2210-qcombin = final.callPackage ./bsp/qrb2210-qcombin.nix { };
  qrb2210-boot = (final.callPackage ./bsp/qrb2210-boot.nix { pkgs = final; }).qrb2210-boot;
}

final: _prev: {
  iq-9075-evk-linux = final.callPackage ./bsp/iq-9075-evk-linux.nix { };
  iq-9075-evk-uboot = final.callPackage ./bsp/iq-9075-evk-uboot.nix { };
  iq-9075-evk-firmware-boot = final.callPackage ./bsp/iq-9075-evk-firmware-boot.nix { };
  iq-9075-evk-partitions = final.callPackage ./bsp/iq-9075-evk-partitions.nix { };
  iq-9075-evk-dtb-bin = final.callPackage ./bsp/iq-9075-evk-dtb-bin.nix { };
  iq-9075-evk-boot = (final.callPackage ./bsp/iq-9075-evk-boot.nix { pkgs = final; }).iq-9075-evk-boot;
}

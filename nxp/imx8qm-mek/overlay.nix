final: _prev: {
  inherit ( final.callPackage ./bsp/u-boot/imx8/imx-uboot.nix { pkgs = final; targetBoard = "imx8qm"; }) ubootImx8 imx-firmware;
}

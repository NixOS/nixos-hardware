final: prev: {
  inherit ( final.callPackage ./bsp/u-boot/imx8/imx-uboot.nix { pkgs = final; targetBoard = "imx8qxp"; }) ubootImx8 imx-firmware;
}

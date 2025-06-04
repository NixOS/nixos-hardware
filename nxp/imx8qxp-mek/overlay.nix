final: _prev: {
  inherit
    (final.callPackage ../common/bsp/imx-uboot.nix {
      pkgs = final;
      targetBoard = "imx8qxp";
    })
    ubootImx8
    imx-firmware
    ;
}

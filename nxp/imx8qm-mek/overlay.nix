final: _prev: {
  inherit
    (final.callPackage ../common/bsp/imx-uboot.nix {
      pkgs = final;
      targetBoard = "imx8qm";
    })
    ubootImx8
    imx-firmware
    ;
}

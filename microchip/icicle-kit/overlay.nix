final: _prev: {
  uboot-icicle-kit = final.callPackage ./../common/bsp/uboot.nix {
    pkgs = final;
    targetBoard = "microchip_mpfs_icicle";
  };
}

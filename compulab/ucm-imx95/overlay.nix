final: _prev: {
  inherit (final.callPackage ./bsp/ucm-imx95-boot.nix { pkgs = final; }) imx95-boot;
}

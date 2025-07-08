final: _prev: {
  inherit (final.callPackage ./bsp/imx8mp-boot.nix { pkgs = final; }) imx8m-boot;
}

final: _prev: {
  inherit (final.callPackage ./bsp/imx93-boot.nix { pkgs = final; }) imx93-boot;
}

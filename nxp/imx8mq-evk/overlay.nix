final: _prev: {
  inherit (final.callPackage ./bsp/imx8mq-boot.nix { pkgs = final; }) imx8m-boot;
}

final: prev: {
  linux_imx8 = final.callPackage ./bsp/linux-imx8.nix { pkgs = final; };
}

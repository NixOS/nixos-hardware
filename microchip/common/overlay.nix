final: prev: {
  linux-icicle-kit = final.callPackage ./bsp/linux-icicle-kit.nix { pkgs = final; boot = prev.uboot-icicle-kit; };
}

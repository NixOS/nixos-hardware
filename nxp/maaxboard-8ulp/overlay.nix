final: _prev: {
  inherit (final.callPackage ./bsp/maaxboard-8ulp-boot.nix { pkgs = final; }) maaxboard-8ulp-boot;
}

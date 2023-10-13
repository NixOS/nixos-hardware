final: prev: {
  linuxPackages_librem5 = final.linuxPackagesFor (final.callPackage ./kernel.nix { });
}

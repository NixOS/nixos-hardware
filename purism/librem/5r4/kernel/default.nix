final: prev: {
  linuxPackages_librem5_6_1_10 = final.linuxPackagesFor (final.callPackage ./6.1.10.nix { });
  linuxPackages_librem5 = final.linuxPackages_librem5_6_1_10;
}

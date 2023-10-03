final: prev: {
  linuxPackages_librem5_6_5_4 = final.linuxPackagesFor (final.callPackage ./6.5.4.nix { });
  linuxPackages_librem5 = final.linuxPackages_librem5_6_5_4;
}

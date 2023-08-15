final: prev: {
  linuxPackages_librem5_6_4_5 = final.linuxPackagesFor (final.callPackage ./6.4.5.nix { });
  linuxPackages_librem5 = final.linuxPackages_librem5_6_4_5;
}

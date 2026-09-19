{ callPackage, linux_7_2, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_7_2;
  patchesFile = ./latest.json;
}

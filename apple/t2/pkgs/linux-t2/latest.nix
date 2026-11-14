{ callPackage, linux_7_3, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_7_3;
  patchesFile = ./latest.json;
}

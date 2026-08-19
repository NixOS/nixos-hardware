{ callPackage, linux_7_1, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_7_1;
  patchesFile = ./latest.json;
}

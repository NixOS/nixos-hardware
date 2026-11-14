{ callPackage, linux_7_0, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_7_3_4;
  patchesFile = ./latest.json;
}

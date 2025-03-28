{ callPackage, linux_6_14, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_6_14;
  patchesFile = ./latest.json;
}

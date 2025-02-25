{ callPackage, linux_6_13, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_6_13;
  patchesFile = ./latest.json;
}

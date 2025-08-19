{ callPackage, linux_6_16, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_6_16;
  patchesFile = ./latest.json;
}

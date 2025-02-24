{ callPackage, linux_6_12, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_6_12;
  patchesFile = ./stable.json;
}

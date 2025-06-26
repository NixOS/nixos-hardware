{ callPackage, linux_6_15, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_6_15;
  patchesFile = ./latest.json;
}

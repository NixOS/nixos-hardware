{ callPackage, linux_6_19, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_6_19;
  patchesFile = ./latest.json;
}

{ callPackage, linux_6_18, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_6_18;
  patchesFile = ./latest.json;
}

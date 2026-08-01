{ callPackage, linux_7_0, ... }@args:

callPackage ./generic.nix args {
  kernel = linux_7_0;
  patchesFile = ./latest.json;
}

{
  lib,
  kernelVersion,
  callPackage,
}:
let
  inherit (lib) versions;

  # Set the version and hash for the kernel sources
  srcVersion =
    if kernelVersion == "longterm" then
      "6.12.19"
    else if kernelVersion == "stable" then
      "6.15.9"
    else
      abort "Invalid kernel version: ${kernelVersion}";

  srcHash =
    if kernelVersion == "longterm" then
      "sha256-1zvwV77ARDSxadG2FkGTb30Ml865I6KB8y413U3MZTE="
    else if kernelVersion == "stable" then
      "sha256-6U86+FSSMC96gZRBRY+AvKCtmRLlpMg8aZ/zxjxSlX0="
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Set the version and hash for the linux-surface releases
  pkgVersion =
    if kernelVersion == "longterm" then
      "6.12.7"
    else if kernelVersion == "stable" then
      "6.15.3"
    else
      abort "Invalid kernel version: ${kernelVersion}";

  pkgHash =
    if kernelVersion == "longterm" then
      "sha256-Pv7O8D8ma+MPLhYP3HSGQki+Yczp8b7d63qMb6l4+mY="
    else if kernelVersion == "stable" then
      "sha256-ozvYrZDiVtMkdCcVnNEdlF2Kdw4jivW0aMJrDynN3Hk="
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Fetch the linux-surface package
  repos =
    callPackage
      (
        {
          fetchFromGitHub,
          rev,
          hash,
        }:
        {
          linux-surface = fetchFromGitHub {
            owner = "linux-surface";
            repo = "linux-surface";
            rev = rev;
            hash = hash;
          };
        }
      )
      {
        hash = pkgHash;
        rev = "arch-${pkgVersion}-1";
      };

  # Fetch and build the kernel package
  inherit (callPackage ../../common/kernel/linux-package.nix { inherit repos; })
    linuxPackage
    surfacePatches
    ;

  kernelPatches = surfacePatches {
    version = pkgVersion;
    patchFn = ../../common/kernel/${versions.majorMinor pkgVersion}/patches.nix;
    patchSrc = (repos.linux-surface + "/patches/${versions.majorMinor pkgVersion}");
  };
in
linuxPackage {
  inherit kernelPatches;
  version = srcVersion;
  sha256 = srcHash;
  ignoreConfigErrors = true;
}

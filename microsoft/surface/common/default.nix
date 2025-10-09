{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkDefault
    mkOption
    types
    versions
    ;

  # Set the version and hash for the kernel sources
  srcVersion =
    with config.hardware.microsoft-surface;
    if kernelVersion == "longterm" then
      "6.12.19"
    else if kernelVersion == "stable" then
      "6.16.9"
    else
      abort "Invalid kernel version: ${kernelVersion}";

  srcHash =
    with config.hardware.microsoft-surface;
    if kernelVersion == "longterm" then
      "sha256-1zvwV77ARDSxadG2FkGTb30Ml865I6KB8y413U3MZTE="
    else if kernelVersion == "stable" then
      "sha256-esjIo88FR2N13qqoXfzuCVqCb/5Ve0N/Q3dPw7ZM5Y0="
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Set the version and hash for the linux-surface releases
  pkgVersion =
    with config.hardware.microsoft-surface;
    if kernelVersion == "longterm" then
      "6.12.7"
    else if kernelVersion == "stable" then
      "6.16.9"
    else
      abort "Invalid kernel version: ${kernelVersion}";

  pkgHash =
    with config.hardware.microsoft-surface;
    if kernelVersion == "longterm" then
      "sha256-Pv7O8D8ma+MPLhYP3HSGQki+Yczp8b7d63qMb6l4+mY="
    else if kernelVersion == "stable" then
      "sha256-grZY2DvEjRrr55D9Ov3I5NpXjgxB7z6bYn8K7iO8fOk="
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Set the commit for the linux-surface release
  pkgRev =
    with config.hardware.microsoft-surface;
    if kernelVersion == "longterm" then
      "add4c31a06d80393e34b6cae07f0f6c92fb2ec31"
    else if kernelVersion == "stable" then
      "94217c2dc8818afd2296c3776223fc1c093f78fb"
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Fetch the linux-surface repository
  repos =
    pkgs.callPackage
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
        rev = pkgRev;
      };

  # Fetch and build the kernel source after applying the linux-surface patches
  inherit (pkgs.callPackage ./kernel/linux-package.nix { inherit repos; })
    linuxPackage
    surfacePatches
    ;
  kernelPatches = surfacePatches {
    version = pkgVersion;
    patchFn = ./kernel/${versions.majorMinor pkgVersion}/patches.nix;
    patchSrc = (repos.linux-surface + "/patches/${versions.majorMinor pkgVersion}");
  };
  kernelPackages = linuxPackage {
    inherit kernelPatches;
    version = srcVersion;
    sha256 = srcHash;
    ignoreConfigErrors = true;
  };

in
{
  options.hardware.microsoft-surface.kernelVersion = mkOption {
    description = "Kernel Version to use (patched for MS Surface)";
    type = types.enum [
      "longterm"
      "stable"
    ];
    default = "longterm";
  };

  config = {
    boot = {
      inherit kernelPackages;

      # Seems to be required to properly enable S0ix "Modern Standby":
      kernelParams = mkDefault [ "mem_sleep_default=deep" ];
    };

    # NOTE: Check the README before enabling TLP:
    services.tlp.enable = mkDefault false;

    # Needed for wifi firmware, see https://github.com/NixOS/nixos-hardware/issues/364
    hardware = {
      enableRedistributableFirmware = mkDefault true;
      sensor.iio.enable = mkDefault true;
    };
  };
}

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkOption types versions;

  # Set the version and hash for the kernel sources
  srcVersion = with config.microsoft-surface;
    if kernelVersion == "longterm" then
      "6.12.19"
    else if kernelVersion == "stable" then
      "6.13.6"
    else
      abort "Invalid kernel version: ${kernelVersion}";

  srcHash = with config.microsoft-surface;
    if kernelVersion == "longterm" then
      "sha256-1zvwV77ARDSxadG2FkGTb30Ml865I6KB8y413U3MZTE="
    else if kernelVersion == "stable" then
      "sha256-3gBTy0E9QI8g/R1XiCGZUbikQD5drBsdkDIJCTis0Zk="
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Set the version and hash for the linux-surface releases
  pkgVersion = with config.microsoft-surface;
    if kernelVersion == "longterm" then
      "6.12.7"
    else if kernelVersion == "stable" then
      "6.13.6"
    else
      abort "Invalid kernel version: ${kernelVersion}";
  
  pkgHash = with config.microsoft-surface;
    if kernelVersion == "longterm" then
      "sha256-Pv7O8D8ma+MPLhYP3HSGQki+Yczp8b7d63qMb6l4+mY="
    else if kernelVersion == "stable" then
      "sha256-otD1ckNxNnvV8xipf9SZpbfg+bBq5EPwyieYtLIV4Ck="
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Fetch the linux-surface package
  repos = pkgs.callPackage ({ fetchFromGitHub, rev, hash }: {
    linux-surface = fetchFromGitHub {
      owner = "linux-surface";
      repo = "linux-surface";
      rev = rev;
      hash = hash;
    };
  }) { hash = pkgHash; rev = "arch-${pkgVersion}-1"; };

  # Fetch and build the kernel package
  inherit (pkgs.callPackage ./kernel/linux-package.nix { inherit repos; }) linuxPackage surfacePatches;
  kernelPatches = surfacePatches {
    version = pkgVersion;
    patchFn = ./kernel/${versions.majorMinor pkgVersion}/patches.nix;
  };
  kernelPackages = linuxPackage {
    inherit kernelPatches; version = srcVersion;
    sha256 = srcHash;
    ignoreConfigErrors=true;
  };

in {
  options.microsoft-surface.kernelVersion = mkOption {
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

{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkOption types;

  shortVersion = config.microsoft-surface.kernelVersion;
  version = if shortVersion == "6.12" then
      "6.12.19"
    else if shortVersion == "6.13" then
      "6.13.6"
    else
      abort "Invalid kernel version: ${shortVersion}";

  rev = "arch-${version}-1";
  
  hash =
    if shortVersion == "6.12" then
      "sha256-Pv7O8D8ma+MPLhYP3HSGQki+Yczp8b7d63qMb6l4+mY="
    else if shortVersion == "6.13" then
      "sha256-otD1ckNxNnvV8xipf9SZpbfg+bBq5EPwyieYtLIV4Ck="
    else
      abort "Invalid kernel version: ${shortVersion}";

  srcHash =
    if shortVersion == "6.12" then
      "sha256-1zvwV77ARDSxadG2FkGTb30Ml865I6KB8y413U3MZTE="
    else if shortVersion == "6.13" then
      "sha256-3gBTy0E9QI8g/R1XiCGZUbikQD5drBsdkDIJCTis0Zk="
    else
      abort "Invalid kernel version: ${shortVersion}";

  inherit (pkgs.callPackage ./kernel/linux-package.nix { repos = pkgs.callPackage ./kernel/repos.nix { rev = rev; hash = hash; }; }) linuxPackage surfacePatches;

  kernelPatches = surfacePatches {
    inherit version;
    patchFn = ./kernel/${shortVersion}/patches.nix;
  };
  kernelPackages = linuxPackage {
    inherit version kernelPatches;
    sha256 = srcHash;
    ignoreConfigErrors=true;
  };

in {
  options.microsoft-surface.kernelVersion = mkOption {
    description = "Kernel Version to use (patched for MS Surface)";
    type = types.enum [
      "6.12"
      "6.13"
    ];
    default = "6.12";
  };

  config = {
    boot = {
      inherit kernelPackages;

      kernelParams = mkDefault [ "mem_sleep_default=deep" ];
      # Seems to be required to properly enable S0ix "Modern Standby":
    };

    # NOTE: Check the README before enabling TLP:
    services.tlp.enable = mkDefault false;

    # i.e. needed for wifi firmware, see https://github.com/NixOS/nixos-hardware/issues/364
    hardware = {
      enableRedistributableFirmware = mkDefault true;
      sensor.iio.enable = mkDefault true;
    };
  };
}

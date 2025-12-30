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
      "6.18.2"
    else
      abort "Invalid kernel version: ${kernelVersion}";

  srcHash =
    with config.hardware.microsoft-surface;
    if kernelVersion == "longterm" then
      "sha256-1zvwV77ARDSxadG2FkGTb30Ml865I6KB8y413U3MZTE="
    else if kernelVersion == "stable" then
      "sha256-VYxrurdJSSs0+Zgn/oB7ADmnRGk8IdOn4Ds6SO2quWo="
    else
      abort "Invalid kernel version: ${kernelVersion}";

  # Fetch the latest linux-surface patches
  linux-surface = pkgs.fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "50d0ed6be462a5fdb643cfe8469bf69158afae42";
    hash = "sha256-VEoZH3dFsLn9GnUyjnbOoJeTRM3KEQ9fhlMk03NXoXs=";
  };

  # Fetch and build the kernel
  inherit (pkgs.callPackage ./kernel/linux-package.nix { })
    linuxPackage
    surfacePatches
    ;

  # Kernel 6.18 can use the same base patches as 6.17
  kernelPatches = surfacePatches {
    version = srcVersion;
    patchFn = ./kernel/${versions.majorMinor srcVersion}/patches.nix;
    patchSrc =
      if (lib.versionOlder (versions.majorMinor srcVersion) "6.18") then
        (linux-surface + "/patches/${versions.majorMinor srcVersion}")
      else
        (linux-surface + "/patches/6.17");
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

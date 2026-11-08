{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins)
    attrNames
    ;

  inherit (lib)
    mkDefault
    mkOption
    types
    versions
    ;

  supportedKernels =
    let
      lts-kernel = {
        version = "6.19.8";
        hash = "sha256-qtpHItuLz6C5cyhRhW1AUIK2pPouOrBnvo2xfN0RWzg=";
      };
      stable-kernel = {
        version = "7.3.1";
        hash = "sha256-+llarZNzT4KcljwqkO98NnMiT9f9rntJQG45fN4t4jE=";
      };

    in
    {
      "longterm" = lts-kernel;
      "stable" = stable-kernel;
    };

  # Set the version and hash for the kernel sources
  srcVersion = supportedKernels.${config.hardware.microsoft-surface.kernelVersion}.version;
  srcHash = supportedKernels.${config.hardware.microsoft-surface.kernelVersion}.hash;

  # Fetch the latest linux-surface patches
  linux-surface = pkgs.fetchFromGitHub {
    owner = "linux-surface";
    repo = "linux-surface";
    rev = "668a0208b4a713641f7f04a73631008b1f522257";
    hash = "sha256-RnlQMpIPTE+QbFlMMwq5Qj95tlVkyRkR8WqaPlivMXM=";
  };

  # Fetch and build the kernel
  inherit (pkgs.callPackage ./kernel/linux-package.nix { })
    linuxPackage
    surfacePatches
    ;
  kernelPatches = surfacePatches {
    version = srcVersion;
    patchFn = ./kernel/${versions.majorMinor srcVersion}/patches.nix;
    patchSrc = linux-surface + "/patches/${versions.majorMinor srcVersion}";
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
    type = types.enum (attrNames supportedKernels);
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

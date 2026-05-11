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
        version = "6.18.13";
        hash = "sha256-7Sw8Vf045oNsCU/ONW8lZ/lRYTC3M1SimFeWA2jFaH8=";
      };
      stable-kernel = {
        version = "7.0.9";
        hash = "sha256-rAes33bPRiHMUYeiZwJwoaaZUzyKayJeSHjEFq2D8cQ=";
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
  linux-surface = (
    if (versions.majorMinor srcVersion == "longterm") then
      pkgs.fetchFromGitHub {
        owner = "linux-surface";
        repo = "linux-surface";
        rev = "829ceccd5970ed3621a30d9fcfb2fe6584a3aab7";
        hash = "sha256-H/qjP2dR5yjUvHUhI6pis+EHHSRXxc4+c4zir/pDA54=";
      }
    else
      (pkgs.fetchFromGitHub {
        owner = "Apiznel";
        repo = "linux-surface";
        rev = "d9173b9ac33e5730fb15f803ddc7c9d91332c174";
        hash = "sha256-Ja5gAVsknjoXZuQGY9grb1pICvsyMnm8ur3mK/711vw=";
      })
  );

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

{ lib, callPackage, linuxPackagesFor, kernelPatches, fetchpatch, ... }:

let
  modDirVersion = "6.3.0-rc3";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-starfive-visionfive2";

      src = fetchFromGitHub {
        owner = "starfive-tech";
        repo = "linux";
        rev = "2a6909fb414dfc72ae391791ec6edc3eedd13e6f";
        sha256 = "sha256-FeY6N+hk0PTpuIuA1hkcS+B+ozn6iHV6YaRVx1kuYHc=";
      };

      inherit modDirVersion;
      kernelPatches = [{ patch = ./fix-memory-size.patch; }] ++ kernelPatches;

      structuredExtraConfig = with lib.kernel; {
        PL330_DMA = no;
        PINCTRL_STARFIVE_JH7110_SYS = yes;
        SERIAL_8250_DW = yes;
      };

      extraMeta.branch = "JH7110_VisionFive2_upstream";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))

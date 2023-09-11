{ lib, callPackage, linuxPackagesFor, kernelPatches, ... }:

let
  modDirVersion = "6.5.0";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-starfive-visionfive2";

      src = fetchFromGitHub {
        owner = "starfive-tech";
        repo = "linux";
        rev = "0dfeb6ace464f0c455a9508815bb9f70760d6faf";
        hash = "sha256-ZDMvEhnJtbyCVNI/WbE80k7ZWOldF491mgx6K/iPgdE=";
      };

      inherit modDirVersion kernelPatches;

      structuredExtraConfig = with lib.kernel; {
        PINCTRL_STARFIVE_JH7110_SYS = yes;
        SERIAL_8250_DW = yes;
      };

      extraMeta.branch = "JH7110_VisionFive2_upstream";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))

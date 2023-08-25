{ lib, callPackage, linuxPackagesFor, kernelPatches, ... }:

let
  modDirVersion = "6.5.0-rc1";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-starfive-visionfive2";

      src = fetchFromGitHub {
        owner = "starfive-tech";
        repo = "linux";
        rev = "67e8df01b875afd312a7d2ab77f56a62f39dd6d9";
        hash = "sha256-H+INnZTrfeCLmxPYbQEu3658/e5/Wz/Y5Ann2+lU6WQ=";
      };

      inherit modDirVersion kernelPatches;

      structuredExtraConfig = with lib.kernel; {
        PINCTRL_STARFIVE_JH7110_SYS = yes;
        SERIAL_8250_DW = yes;
      };

      extraMeta.branch = "JH7110_VisionFive2_upstream";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))

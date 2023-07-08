{ lib, callPackage, linuxPackagesFor, kernelPatches, ... }:

let
  modDirVersion = "6.4.0";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-starfive-visionfive2";

      src = fetchFromGitHub {
        owner = "starfive-tech";
        repo = "linux";
        rev = "e5a381c51d624ffd8784db908a58ae227d0608a4";
        sha256 = "sha256-gg3+2ITdnpo49UmySiAJnk47STW1I7kF7fsKGBVayRE=";
      };

      inherit modDirVersion;
      kernelPatches = [{
        name = "verisilicon";
        patch = ./verisilicon.patch;
      }] ++ kernelPatches;

      structuredExtraConfig = with lib.kernel; {
        PINCTRL_STARFIVE_JH7110_SYS = yes;
        SERIAL_8250_DW = yes;
      };

      extraMeta.branch = "JH7110_VisionFive2_upstream";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))

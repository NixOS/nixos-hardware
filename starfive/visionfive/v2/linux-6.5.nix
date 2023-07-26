{ lib, callPackage, linuxPackagesFor, kernelPatches, ... }:

let
  modDirVersion = "6.5.0-rc1";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-starfive-visionfive2";

      src = fetchFromGitHub {
        owner = "starfive-tech";
        repo = "linux";
        rev = "64a6c57ec372c44d0f25416c9614657e274fccff";
        hash = "sha256-ZOCCj/VyUZa36+q6sUnE+qA0FcNCFnQjIUils0hBb28=";
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

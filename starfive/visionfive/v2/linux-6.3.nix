{ lib, callPackage, linuxPackagesFor, kernelPatches, fetchpatch, ... }:

let
  modDirVersion = "6.3.0-rc4";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-starfive-visionfive2";

      src = fetchFromGitHub {
        owner = "starfive-tech";
        repo = "linux";
        rev = "a57bdb1d13f93c8fc1b3c668cc74d585bb20f3f8";
        sha256 = "sha256-jnQnJChIGCyJt+zwGfUTsMhrwmWek/ngIM6Pae6OXuI=";
      };

      inherit modDirVersion;
      kernelPatches = [
        { patch = ./fix-memory-size.patch; }
        {
          patch = fetchpatch {
            url =
              "https://github.com/torvalds/linux/commit/d83806c4c0cccc0d6d3c3581a11983a9c186a138.diff";
            hash = "sha256-xUnEJkzQRIIBF/0GIpS0Cd+h6OdSiJlyva5xwxtleE0=";
          };
        }
      ] ++ kernelPatches;

      structuredExtraConfig = with lib.kernel; {
        PL330_DMA = no;
        PINCTRL_STARFIVE_JH7110_SYS = yes;
        SERIAL_8250_DW = yes;
      };

      extraMeta.branch = "JH7110_VisionFive2_upstream";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))

{
  lib,
  callPackage,
  linuxPackagesFor,
  kernelPatches,
  ...
}:

let
  modDirVersion = "6.0.0";

  linuxPkg =
    { fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (
      args
      // {
        inherit modDirVersion kernelPatches;
        version = "${modDirVersion}-starfive-visionfive-v1";

        src = fetchFromGitHub {
          owner = "starfive-tech";
          repo = "linux";
          rev = "cfcb617265422c0af0ae5bc9688dceba2d10b27a";
          sha256 = "sha256-EAMCOtJZ51xSLySQPaZyomfa/1Xs9kNedz04tIbELqg=";
        };

        defconfig = "starfive_jh7100_fedora_defconfig";

        structuredExtraConfig = with lib.kernel; {
          KEXEC = yes;
          SERIAL_8250_DW = yes;
          PINCTRL_STARFIVE = yes;
          DW_AXI_DMAC_STARFIVE = yes;
          PTP_1588_CLOCK = yes;
          STMMAC_ETH = yes;
          STMMAC_PCI = yes;
        };

        extraMeta.branch = "visionfive";
      }
      // (args.argsOverride or { })
    );
in
lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))

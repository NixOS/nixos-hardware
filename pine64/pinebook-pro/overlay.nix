final: super:

let
  inherit (final) callPackage kernelPatches linuxPackagesFor;
  kernels = callPackage ./kernel { };
in
{
  pinebookpro-manjaro-kernel = kernels.manjaro-kernel;
  pinebookpro-ap6256-firmware = callPackage ./firmware/ap6256-firmware { };
  pinebookpro-keyboard-updater = callPackage ./keyboard-updater { };
}

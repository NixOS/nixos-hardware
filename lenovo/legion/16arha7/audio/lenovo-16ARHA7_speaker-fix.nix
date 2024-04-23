# Patch sourced from https://github.com/christian-bendiksen/kernel-6.8.0-63.16ARHA7.fc40
{ pkgs, lib, kernel ? pkgs.linuxPackages_latest.kernel }:

pkgs.stdenv.mkDerivation {
  pname = "lenovo-16ARHA7-speaker-fix-module";
  inherit (kernel) src version postPatch nativeBuildInputs;

  kernel_dev = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  modulePath = "sound/pci/hda/";

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installPhase = ''
    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install
  '';

	patches = [ ./lenovo_16ARHA7_sound_fix.patch ];

  meta = {
    description = "Patch to get the speakers working for Lenovo Legion Slim 7 Gen 7 AMD (16ARHA7)";
    license = lib.licenses.gpl3;
  };
}
{
  stdenv,
  lib,
  kernel,
  kernelModuleMakeFlags,
  fetchFromGitHub,
}:

# The fix pack's fork of intel/vision-drivers' intel_cvs, for the IR path.
#
# hm1092 asks the bridge to configure CSI-2 port-2 forwarding through a weak
# reference to cvs_send_mipi_ir_config(). That symbol does not exist in
# intel/vision-drivers itself -- the rev ../../intel-cvs builds (845d6f8)
# exports no symbols at all -- it is fork-authored, along with everything else
# on the working IR path: the len==1 sentinel in cvs_write_i2c selecting a
# verbatim Windows-capture IR HOST_SET_MIPI_CONFIG payload, and a probe-time
# 0x830 send carrying this camera's SSDB-style geometry. Without this module
# the weak reference resolves NULL, hm1092 logs "port-2 forwarding NOT
# configured", and IR was only ever measured working with the fork loaded.
#
# Same module name, so it REPLACES ../../intel-cvs rather than sitting beside
# it: default.nix only adds the plain intel-cvs when irCamera is disabled, so
# exactly one intel_cvs.ko is ever in the aggregated module tree. Everything
# the plain build does at probe (ownership handshake, SSDB 0x830), this build
# also does.
#
# Pinned to the fork rather than jibsta210 upstream because this exact rev is
# what was runtime-verified: tag nixos-pin-2026-08-27, whose default build
# compiles the fork's bring-up diagnostics out (DEBUG_CVS, off unless built
# with `make DEBUG_CVS=1`) and was DKMS boot-tested on a DA14260 on
# 7.1.8-arch1-2-ptl -- face authentication succeeded through it, with the
# bridge reporting GET_DEVICE_STATE = 0x06 after the stream-start 0x830. The
# fork also already removed the spurious IRQF_ONESHOT that ../../intel-cvs
# has to patch out of 845d6f8, so there is no postPatch here.
stdenv.mkDerivation (finalAttrs: {
  pname = "intel-cvs-ir";
  # dkms.conf declares PACKAGE_VERSION="1.0"; the rev is tag
  # nixos-pin-2026-08-27 on the fork.
  version = "1.0-unstable-2026-08-27";

  src = fetchFromGitHub {
    owner = "HritwikSinghal";
    repo = "svp7500-camera-fix-pack";
    tag = "nixos-pin-2026-08-27";
    hash = "sha256-+vWsihrgfU0AXi2PFRmM6AYjVyDCTQcTfa0Gv+TkSso=";
  };

  sourceRoot = "${finalAttrs.src.name}/dkms/intel-cvs-1.0";

  hardeningDisable = [
    "pic"
    "format"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # Drive kbuild directly, same shape as ../default.nix (the gasket idiom):
  # keeps the stdenv phases and their flag-array handling intact, and skips
  # the bundled Makefile's wrapper targets.
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];

  buildFlags = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = {
    description = "Intel CVS (Synaptics SVP7500) bridge driver, fix-pack fork with IR port-2 forwarding";
    homepage = "https://github.com/HritwikSinghal/svp7500-camera-fix-pack";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
})

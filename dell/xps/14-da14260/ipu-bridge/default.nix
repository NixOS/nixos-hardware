{
  stdenv,
  lib,
  kernel,
  kernelModuleMakeFlags,
}:

# The kernel's own ipu-bridge with the Himax HM1092 (IR camera) entry removed.
#
# Kernels after 7.2 list HIMX1092 in ipu_supported_sensors[] (mainline
# 4fdb0342f05e), so ipu-bridge builds a software node and a CSI-2 endpoint
# for it. intel_ipu7_isys then adds an async connection per endpoint and only
# runs its notifier's `complete` callback -- the one that registers every
# subdev's /dev/v4l-subdevN node and logs "All sensor registration completed."
# -- once all of them are bound. With no hm1092 driver (irCamera disabled) the
# IR sensor never binds, the notifier never completes, and the RGB sensor
# (ov08x40) is left without a device node: the camera HAL then fails with
# "Failed to find DevName ... ov08x40" and VIDIOC_STREAMON returns EPIPE.
#
# Dropping the entry means the bridge never describes a sensor nobody drives.
# Installed under updates/, so depmod prefers it over the in-tree
# ipu-bridge.ko; only add it where the IR camera is off.
stdenv.mkDerivation {
  name = "ipu-bridge-no-himx1092-${kernel.version}";

  inherit (kernel) src;

  # The kernel source is a tarball; take just the one file. The sed is
  # followed by a grep so a kernel that renames or drops the entry fails the
  # build instead of silently shipping an unmodified copy.
  unpackPhase = ''
    runHook preUnpack
    tar -xf $src --strip-components=5 --wildcards '*/drivers/media/pci/intel/ipu-bridge.c'
    runHook postUnpack
  '';

  postPatch = ''
    sed -i -e '/\/\* Himax HM1092 \*\//d' -e '/IPU_SENSOR_CONFIG("HIMX1092"/d' ipu-bridge.c
    if grep -q HIMX1092 ipu-bridge.c; then
      echo "ipu-bridge.c still lists HIMX1092 after patching" >&2
      exit 1
    fi
    echo 'obj-m := ipu-bridge.o' > Kbuild
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # kernelModuleMakeFlags carries nixpkgs' `cmd_sign=kmodigest` override, which
  # gives the module the deterministic .ko.cer the kernel-modules aggregator
  # cats; same reasoning as ../ipu7-drivers.
  buildPhase = ''
    runHook preBuild
    make ${lib.escapeShellArgs kernelModuleMakeFlags} \
      -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD modules
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make ${lib.escapeShellArgs kernelModuleMakeFlags} \
      -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD \
      INSTALL_MOD_PATH=$out INSTALL_MOD_DIR=updates modules_install
    runHook postInstall
  '';

  meta = {
    description = "Intel IPU sensors bridge without the Himax HM1092 entry";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}

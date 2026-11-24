{
  stdenv,
  lib,
  kernel,
  kernelModuleMakeFlags,
  fetchFromGitHub,
}:

# Kernels >= 6.17 ship an IPU7 core and ISys in drivers/staging/media/ipu7,
# but no PSys, so they cannot drive the hardware ISP that the camera HAL
# needs. This package supplies just the PSys module (intel-ipu7-psys), which
# has no in-tree counterpart, and links it against the in-tree core and ISys
# that already enumerate the sensor.
#
# Vendored from nixpkgs PR #542085; drop once that merges and use
# config.boot.kernelPackages.ipu7-drivers instead.
stdenv.mkDerivation {
  name = "ipu7-drivers-${kernel.version}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "ipu7-drivers";
    rev = "495acc90feb09d8008c0a6228fb8bb4c6415ca62";
    hash = "sha256-a2hIJ4wMCHQeDb4gp+5pjLizJ/CCfA0JivVDWeqB4vY=";
  };

  # This repo's own ipu7-bus.h (used to build PSys, via psys/Makefile's
  # `-I$(src)/../`) appends acquire_fw_task_buffer_lock and
  # get_running_fw_task_count to struct ipu7_bus_device. The in-tree staging
  # driver that actually allocates the struct (kernel >= 6.17) doesn't have
  # them, so PSys writes a function pointer 8 bytes past the end of the
  # kmalloc-1k slab object, corrupting whatever neighbour lives there — on
  # shutdown this reliably/intermittently (depending on the slab neighbour)
  # trips list_del corruption in device_shutdown() on reboot. See
  # https://github.com/intel/ipu7-drivers/issues/93 (still open upstream).
  #
  # Fix: drop the two fields from the patch (they only pair with this repo's
  # own out-of-tree MMU code, which isn't loaded alongside the in-tree core),
  # and overwrite this repo's copies of the staging headers with the running
  # kernel's own, so PSys is compiled against the exact ABI the in-tree
  # core/ISys actually allocate.
  patches = [ ./ipu7-psys-in-tree-abi.patch ];

  postPatch = ''
    tar -xf ${kernel.src} --strip-components=5 \
      -C drivers/media/pci/intel/ipu7 --wildcards '*/drivers/staging/media/ipu7/*.h'
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # kernelModuleMakeFlags carries nixpkgs' `cmd_sign=kmodigest` override, which
  # gives each module the deterministic .ko.cer the kernel-modules aggregator
  # cats; without it intel-ipu7-psys.ko has none and the whole system build
  # fails. Same as the sibling ipu6-drivers.
  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    substituteInPlace Makefile \
      --replace-fail "INSTALL_MOD_DIR=" "INSTALL_MOD_PATH=$out INSTALL_MOD_DIR="
  '';

  installTargets = [ "modules_install" ];

  meta = {
    homepage = "https://github.com/intel/ipu7-drivers";
    description = "Intel IPU7 PSys kernel driver";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}

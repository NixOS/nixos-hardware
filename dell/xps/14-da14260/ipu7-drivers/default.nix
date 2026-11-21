{
  stdenv,
  lib,
  kernel,
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

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
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

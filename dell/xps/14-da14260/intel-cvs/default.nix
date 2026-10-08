{
  stdenv,
  lib,
  kernel,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  name = "intel-cvs-${kernel.version}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "vision-drivers";
    rev = "845d6f8bdf66ff1f455901da9de5e00a53a83dce";
    hash = "sha256-i/qZN8GXyqaE6n6pRtxQLdmGhmPDjoArzVvflDmwuSs=";
  };

  # Remove IRQF_ONESHOT from a non-threaded IRQ handler — passing this flag
  # to devm_request_irq() (not devm_request_threaded_irq) triggers a kernel
  # WARNING and makes IRQ delivery unreliable, causing the SVP7500 bridge to
  # wedge after idle. Fix confirmed upstream-worthy (intel/vision-drivers#37).
  postPatch = ''
    substituteInPlace drivers/misc/icvs/intel_cvs.c \
      --replace-fail "IRQF_ONESHOT | IRQF_NO_SUSPEND" "IRQF_NO_SUSPEND"
  '';

  hardeningDisable = [
    "pic"
    "format"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  installTargets = [ "modules_install" ];

  meta = {
    description = "Intel CVS (Synaptics SVP7500) camera bridge driver";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}

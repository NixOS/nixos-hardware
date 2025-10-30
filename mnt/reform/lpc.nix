{
  stdenv,
  lib,
  fetchFromGitLab,
  kernel,
  kernelModuleMakeFlags,
  kmod,
}:

stdenv.mkDerivation rec {
  name = "lpc";

  src = fetchFromGitLab {
    domain = "source.mnt.re";
    owner = "reform";
    repo = "reform-tools";
    rev = "45f930403492aa2156522bfe30edb02e33494b69";
    hash = "sha256-no33CsV69nu1TR0cqxQDd1bFXqhjqOW9IUDxds0fyxE=";
  };

  sourceRoot = "source/lpc";
  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  installPhase = ''
    make -C "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" M="$(pwd)" INSTALL_MOD_PATH=$out modules_install $makeFlags
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
}

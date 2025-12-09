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
    rev = "95fff02ea84386e4e9815ee650032b1a5bd6107c";
    hash = "sha256-bFiVvpLTboxhA5SmMcf60iazEsgFehabsdqZMZ3APuI=";
  };

  sourceRoot = "source/lpc";
  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  installPhase = ''
    runHook preInstall
    make -C "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" M="$(pwd)" INSTALL_MOD_PATH=$out modules_install $makeFlags
    runHook postInstall
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];
}

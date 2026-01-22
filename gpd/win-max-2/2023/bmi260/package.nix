{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation (finalAttr: {
  pname = "bmi260";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = finalAttr.pname;
    rev = "v${finalAttr.version}";
    hash = "sha256-So8rWDTXYsMUgLBU9WrJp47txA8dI98tcxXNy92AYgg=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    runHook preInstall

    install *.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/bmi260

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/bmi260";
    description = "A kernel driver for the Bosch BMI260 IMU";
    license = with licenses; [
      bsd3
      gpl2Only
    ];
    maintainers = with maintainers; [ Cryolitia ];
    platforms = [ "x86_64-linux" ];
  };
})

{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, kernel
}:

stdenv.mkDerivation (finalAttr: {
  pname = "bmi260";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "hhd-dev";
    repo = finalAttr.pname;
    rev = "v${finalAttr.version}";
    hash = "sha256-J0npD75QqOGY1QUoznBjQ+jX28gq5u6b0JZOseclwE8=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall

    install *.ko -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/bmi260

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/hhd-dev/bmi260";
    description = "A kernel module driver for the Bosch BMI260 IMU";
    license = with licenses; [ bsd3 gpl2Only ];
    maintainers = with maintainers; [ Cryolitia ];
    platforms = platforms.linux;
  };
})

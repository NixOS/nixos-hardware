{
  stdenv,
  fetchFromGitHub,
  xxd,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "pinebook-pro-keyboard-updater";
  version = "2021-07-28";

  nativeBuildInputs = [
    xxd
  ];

  buildInputs = [
    libusb1
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v updater $out/bin
  '';

  src = fetchFromGitHub {
    owner = "dragan-simic";
    repo = "pinebook-pro-keyboard-updater";
    rev = "bd8d2ea48992b3e6ddd0b9435d21b74cdcf97224";
    hash = "sha256-3+Qsa5lk1EJrLvPSyWthqBMTqJCigbJSmnsS6hdu+w8=";
  };
}

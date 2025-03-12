{ fetchFromGitHub
, lib
, stdenvNoCC
, ...
}:
stdenvNoCC.mkDerivation {
  pname = "orangepi-firmware";
  version = "2024.10.09";
  dontBuild = true;
  dontFixup = true;
  compressFirmware = false;

  src = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "firmware";
    rev = "75ea6fc5f3c454861b39b33823cb6876f3eca598";
    hash = "sha256-X+n0voO3HRtPPAQsajGPIN9LOfDKBxF+8l9wFwGAFSQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware
    cp -a * $out/lib/firmware/

    runHook postInstall
  '';

  meta.license = lib.licenses.unfreeRedistributableFirmware;
}

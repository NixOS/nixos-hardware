{
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "edk2-spacemit-k3";
  version = "ubuntu26.04-20260509";

  src = fetchFromGitHub {
    owner = "spacemit-com";
    repo = "K3-Ubuntu-Images";
    tag = "ubuntu26.04-20260509";
    hash = "sha256-J0T3T/gOhKmld1du7J2z+DimZXShb+zoON3DHIz4Hy0=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp gadget.in/edk2.itb $out/

    runHook postInstall
  '';
}

{ pkgs, ... }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "hss";
  version = "v2022.09";

  src = fetchFromGitHub {
    owner = "polarfire-soc";
    repo = "hart-software-services";
    rev = version;
    sha256 = "sha256-j/nda7//CjJW09zt/YrBy6h+q+VKE5t/ueXxDzwVWQ0=";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = with buildPackages; [
    libyaml
    elfutils
    openssl
    zlib
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace ./tools/hss-payload-generator/Makefile \
      --replace "/bin/bash" "bash"

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    make -C ./tools/hss-payload-generator

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp ./tools/hss-payload-generator/hss-payload-generator $out

    runHook postConfigure
  '';
}

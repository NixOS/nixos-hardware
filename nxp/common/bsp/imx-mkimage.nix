{ pkgs }:

with pkgs;
pkgs.stdenv.mkDerivation rec {
  pname = "imx-mkimage";
  version = "lf-5.15.32-2.0.0";
  src = fetchgit {
    url = "https://github.com/nxp-imx/imx-mkimage.git";
    rev = version;
    sha256 = "sha256-vJuWK2GOAtps798QY1I6xIcixgenJmntrh24s9KtsKU=";
    leaveDotGit = true;
  };

  postPatch = ''
    substituteInPlace Makefile \
        --replace 'CC = gcc' 'CC = clang'
  '';

  depsBuildBuild = [
    pkgs.buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    clang
    git
    glibc.static
  ];

  makeFlags = [
    "bin"
  ];

  installPhase = ''
    install -m 0755 mkimage_imx8 $out
  '';
}

{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "spi_tool";
  version = "unstable-2023-04-14";
  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "Tools";
    rev = "693661d4ba314424f76c06da1bbb799e9b534c9f";
    hash = "sha256-POWwpIIPnquJs/bpC3Pn94skua3SZvyfICPBglO7HnU=";
    sparseCheckout = [ "spl_tool" ];
  };
  sourceRoot = "source/spl_tool";
  installPhase = ''
    mkdir -p $out/bin
    cp spl_tool $out/bin
  '';
}

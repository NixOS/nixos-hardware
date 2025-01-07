{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation (finalAttrs: {
  pname = "spi_tool";
  version = "0x01010101";
  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "soft_3rdpart";
    rev = "89ff3396250538548643c3322f74640712b80893";
    sha256 = "sha256-Ni3pBWKgr4bYJb/uJ+5EbSQl6JwWoO2lZFk2Xpi63IA=";
    sparseCheckout = [ "spl_tool" ];
  };
  sourceRoot = "source/spl_tool";
  installPhase = ''
    mkdir -p $out/bin
    cp spl_tool $out/bin
  '';
})

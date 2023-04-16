{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec{
  pname = "spi_tool";
  version = "0x01010101";
  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "soft_3rdpart";
    rev = "cd7b50cd9f9eca66c23ebd19f06a172ce0be591f";
    sha256 = "sha256-hRmP74gz0Y9KnSwXCjxEiArJE+FonI9rGghZTK54qGs=";
    sparseCheckout = [ "spl_tool" ];
  };
  sourceRoot = "source/spl_tool";
  installPhase = ''
    mkdir -p $out/bin
    cp spl_tool $out/bin
  '';
}

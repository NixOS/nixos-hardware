{ pkgs }:

with pkgs;
pkgs.stdenv.mkDerivation rec {
  pname = "imx-mkimage";
  version = "lf-5.15.32-2.0.0";

  src = fetchgit {
    url = "https://source.codeaurora.org/external/imx/imx-mkimage.git";
    rev = version;
    sha256 = "sha256-31pib5DTDPVfiAAoOSzK8HWUlnuiNnfXQIsxbjneMCc=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    git
  ];

  buildInputs = [
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

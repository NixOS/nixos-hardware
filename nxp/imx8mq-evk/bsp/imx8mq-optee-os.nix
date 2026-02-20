{ pkgs }:
pkgs.callPackage ../../common/bsp/imx-optee-builder.nix {
  pname = "imx8mq-optee-os";
  version = "lf-6.1.55-2.2.0";

  src = pkgs.fetchgit {
    url = "https://github.com/nxp-imx/imx-optee-os.git";
    rev = "a303fc80f7c4bd713315687a1fa1d6ed136e78ee";
    sha256 = "sha256-OpyG812DX0c06bRZPKWB2cNu6gtZCOvewDhsKgrGB+s=";
  };

  platformFlavor = "mx8mqevk";
}

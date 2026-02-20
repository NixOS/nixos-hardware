{ pkgs }:
pkgs.callPackage ../../common/bsp/imx-optee-builder.nix {
  pname = "imx8mp-optee-os";
  version = "lf-6.12.20-2.0.0";

  src = pkgs.fetchgit {
    url = "https://github.com/nxp-imx/imx-optee-os.git";
    rev = "87964807d80baf1dcfd89cafc66de34a1cf16bf3";
    sha256 = "sha256-AMZUMgmmyi5l3BMT84uubwjU0lwNObs9XW6ZCbqfhmc=";
  };

  platformFlavor = "mx8mpevk";
}

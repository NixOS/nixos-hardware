{ pkgs, fetchgit }:
pkgs.callPackage ../../common/bsp/imx-uboot-builder.nix {
  pname = "imx93-uboot";
  version = "2024.04";

  src = fetchgit {
    url = "https://github.com/nxp-imx/uboot-imx.git";
    #lf_v2024.04
    rev = "e3219a5a73445219df605d1492687918d488055c";
    sha256 = "sha256-6pXwgNzq4/XUUEmJ6sGC5pII4J5uMvlDPE9QJxjJJbQ=";
  };

  defconfig = "imx93_11x11_evk_defconfig";
  ramdiskAddr = "0x85000000";
  fdtAddr = "0x84000000";
  dtbPath = "./arch/arm/dts/imx93-11x11-evk.dtb";
}

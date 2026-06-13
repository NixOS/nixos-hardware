{ pkgs, fetchgit }:
pkgs.callPackage ../../common/bsp/imx-uboot-builder.nix {
  pname = "maaxboard-8ulp-uboot";
  version = "2022.04";

  src = fetchgit {
    url = "https://github.com/Avnet/uboot-imx.git";
    rev = "2d5adab3314a240be9f23cff80841117849209fd";
    sha256 = "sha256-gLJWsmRN0wi5lAeehWO+Qur9GMjAY/jHRgKK7DydcKc=";
  };

  defconfig = "maaxboard-8ulp_defconfig";
  ramdiskAddr = "0x85000000";
  fdtAddr = "0x84000000";
  dtbPath = "./arch/arm/dts/maaxboard-8ulp.dtb";
}

{ pkgs, fetchgit }:
pkgs.callPackage ../../common/bsp/imx-uboot-builder.nix {
  pname = "imx8mp-uboot";
  version = "2025.04";

  src = fetchgit {
    url = "https://github.com/nxp-imx/uboot-imx.git";
    # tag: lf-6.12.20-2.0.0
    rev = "9383f8387dc76524524da69992db96c22195a57c";
    sha256 = "sha256-httRSwN8NiKOdL7fZEvN/4AbypGQfegYtJgxKIea+Zg=";
  };

  defconfig = "imx8mp_evk_defconfig";
  ramdiskAddr = "0x45000000";
  fdtAddr = "0x44000000";
  dtbPath = "./dts/upstream/src/arm64/freescale/imx8mp-evk.dtb";
}

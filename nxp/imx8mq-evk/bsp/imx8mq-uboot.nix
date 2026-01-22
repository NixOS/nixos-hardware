{ pkgs, fetchgit }:
pkgs.callPackage ../../common/bsp/imx-uboot-builder.nix {
  pname = "imx8mq-uboot";
  version = "2023.04";

  src = fetchgit {
    url = "https://github.com/nxp-imx/uboot-imx.git";
    # tag: "lf-6.1.55-2.2.0"
    rev = "49b102d98881fc28af6e0a8af5ea2186c1d90a5f";
    sha256 = "sha256-1j6X82DqezEizeWoSS600XKPNwrQ4yT0vZuUImKAVVA=";
  };

  defconfig = "imx8mq_evk_defconfig";
  ramdiskAddr = "0x45000000";
  fdtAddr = "0x44000000";
  dtbPath = "./arch/arm/dts/imx8mq-evk.dtb";
}

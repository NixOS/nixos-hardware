{ fetchFromGitHub, buildUBoot }:

buildUBoot rec {
  version = "3.7.5";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "refs/tags/VF2_v${version}";
    hash = "sha256-/BCWN+lbMaOakfwwCDloutFEX8IYQyCIrkE1Yu6T8oI=";
  };

  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}

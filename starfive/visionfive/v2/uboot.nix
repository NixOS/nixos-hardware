{ fetchFromGitHub, buildUBoot }:

buildUBoot {
  version = "2021.10";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "ac0ac696256abf412826d74ee918dd417e207d7b";
    sha256 = "sha256-cyEMKkTIiET8hnWgD6poZSzfjmRAqUtyRQM0yvNY230=";
  };

  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}

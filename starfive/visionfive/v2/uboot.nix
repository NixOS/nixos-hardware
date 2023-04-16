{ fetchFromGitHub, buildUBoot }:

buildUBoot {
  version = "2021.10";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "688befadf1d337dee3593e6cc0fe1c737cc150bd";
    sha256 = "sha256-RGADEJRZyuzjblxowdHnhj78eMJBIWnvkwEcpSen5Oo=";
  };

  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}

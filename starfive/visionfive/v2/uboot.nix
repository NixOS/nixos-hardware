{ fetchFromGitHub, buildUBoot }:

buildUBoot rec {
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "refs/tags/VF2_v${version}";
    hash = "sha256-735V8HMCGKj13cgQJv7FYrBIF3mYWOrmJhr+46nsVuY=";
  };

  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}

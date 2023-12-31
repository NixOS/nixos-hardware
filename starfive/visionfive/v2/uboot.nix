{ fetchFromGitHub, buildUBoot }:

buildUBoot rec {
  version = "5.10.3";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "refs/tags/JH7110_VF2_6.1_v${version}";
    hash = "sha256-4E/AxPCFCluwJBEf6xGuxAi1hPZK5ZxEs5WlBVVfvYE=";
  };

  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}

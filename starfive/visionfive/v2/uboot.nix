{ fetchFromGitHub, buildUBoot }:

buildUBoot rec {
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "u-boot";
    rev = "refs/tags/VF2_v${version}";
    hash = "sha256-Vd8vhSZE9fJ+Gp5IbLlqz7JAT9ChJ66krxb7gpLJ4P8=";
  };

  defconfig = "starfive_visionfive2_defconfig";
  filesToInstall = [
    "u-boot.bin"
    "arch/riscv/dts/starfive_visionfive2.dtb"
    "spl/u-boot-spl.bin"
    "tools/mkimage"
  ];
}
